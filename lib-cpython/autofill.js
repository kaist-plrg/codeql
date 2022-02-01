const cp = require('child_process');
const fs = require('fs');
// helpers
function read(filename) { return fs.readFileSync(filename); }
function readLines(filename) { return read(filename).toString().split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function writeLines(filename, lines) { write(filename, lines.join('\n')); }
function walk(dir, ext) {
    var results = [];
    var list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = dir + '/' + file;
        var stat = fs.statSync(file);
        if (stat && stat.isDirectory()) { 
            /* Recurse into a subdirectory */
            results = results.concat(walk(file, ext));
        } else if (file.endsWith(ext)) {
            /* Is a file */
            results.push(file);
        }
    });
    return results;
}
Array.prototype.unique = function() {
  return [...new Set(this)];
}
Array.prototype.last = function() {
  return this[this.length - 1]
}

// variables
const lang1 = "python";
const lang2 = "cpp";

const Lang1 = "Python";
const Lang2 = "Cpp";

const LANG1 = "PYTHON";
const LANG2 = "CPP";

const merged = "cpython";

const cmd = `codeql query compile ql/main.ql`;

function createClass(type, i, types) {
  let parent = "";
  for (cand of types) {
    if (cand != type && type.endsWith(cand)) {
      parent = cand;
      break;
    }
  }

  if (parent) return `class ${type} extends ${parent} {
  ${type}() {
    as${Lang1}${parent}() instanceof ${LANG1}::${type}
    or
    as${Lang2}${parent}() instanceof ${LANG2}::${type}
  }

  ${LANG1}::${type} as${Lang1}${type}() { result = as${Lang1}${parent}() }
  ${LANG2}::${type} as${Lang2}${type}() { result = as${Lang2}${parent}() }

  /* member predicates for ${type} */
}`;

  else return `private newtype T${type} =
  T${Lang1}${type}(${LANG1}::${type} c)
  or
  T${Lang2}${type}(${LANG2}::${type} c)
class ${type} extends T${type} {
  ${LANG1}::${type} as${Lang1}${type}() { this = T${Lang1}${type}(result) }
  ${LANG2}::${type} as${Lang2}${type}() { this = T${Lang2}${type}(result) }

  string toString() {
    result = as${Lang1}${type}().toString()
    or
    result = as${Lang2}${type}().toString()
  }

  /* member predicates for ${type} */
}`;
}

function createPredicate(sig, i) {
  let [name, arity] = sig.split('/');
  let arr = [...new Array(+arity).keys()]; // 0 to arity-1
  let retT = `MyType${i}`;
  let params = arr.map(j => `${retT}_${j} p${j}`).join(', ');
  let args1 = arr.map(j => `p${j}.as${Lang1}${retT}_${j}()`).join(', ');
  let args2 = arr.map(j => `p${j}.as${Lang2}${retT}_${j}()`).join(', ');

  let typedefs = `class ${retT} = TMyType;\n` + arr.map(j => `class ${retT}_${j} = TMyType;\n`).join('');

  return typedefs + `${retT} ${name}(${params}) {
  result.as${Lang1}${retT}() = ${LANG1}::${name}(${args1})
  or
  result.as${Lang2}${retT}() = ${LANG2}::${name}(${args2})
}`;
}

function print(content, idx, arr) {
  console.log(content);
}

function replace(pair) {
  const [from, to] = pair.split(':');

  let i;
  for(i = 0; i < origMerged.length; i++) {
    if (!origMerged[i].startsWith('class MyType'))
      origMerged[i] = origMerged[i].replace(`${from} `, `${to} `).replace(`${from}(`, `${to}(`);
  }
}

function afterEqual(str) {
  return str.slice(str.indexOf('=') + 2);
}

function toPurePredicate(predicate) {
  let i;
  for(i = 0; i < origMerged.length; i++) {
    let line = origMerged[i].trim();
    let indent = origMerged[i].indexOf('MyType');
    if (line.includes(predicate) && indent >= 0) {
      let tokens = line.split(' ');
      tokens.splice(0, 1, 'predicate');
      origMerged[i] = ' '.repeat(indent) + tokens.join(' ');

      origMerged[i+1] = ' '.repeat(indent + 2) + afterEqual(origMerged[i+1]);
      origMerged[i+3] = ' '.repeat(indent + 2) + afterEqual(origMerged[i+3]);
    }
  }
}

function appendMemberPredicate(pred, i) {
  // pred = 'Cls::name(arg1, arg2'
  let [cls, sig] = pred.split('::');
  let [name, raw_params] = sig.split('(');
  let params = raw_params ? raw_params.split(', ') : [];

  let retT = `MyType${i}`;

  for(j=0; j<origMerged.length; j++) {
    if (origMerged[j] == `  /* member predicates for ${cls} */`) {
      // currently, all param for member predicates are all primitives, so no need casting for param types
      origMerged[j] += `
  ${retT} ${name}(${params.map((p, idx) => p + ' p' + idx).join(', ')}) {
    result.as${Lang1}${retT}() = as${Lang1}${cls}().${name}(${params.map((p, idx) => 'p' + idx).join(', ')})
    or
    result.as${Lang2}${retT}() = as${Lang2}${cls}().${name}(${params.map((p, idx) => 'p' + idx).join(', ')})
  }`;
      origMerged.push(`class ${retT} = TMyType;`);
      break;
    }
  }
}

function printHeader() {
  console.log(
`import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TMyType = TMyConstructor()`
  );
}

function printBody() {
  cp.exec(cmd, (err, stdout, stderr) => {
    if(err) {
      let lines = stderr.split('\n');

      /* Create Classes */
      // ERROR: Could not resolve type Type (/path/to/lib.qll:r,c1-c2)
      let types = lines
        .filter(str => str.startsWith("ERROR: Could not resolve type "))
        .map(str => str.split(' ')[5])
        .filter(type => !(type.includes('Ap') || type=='LocalCc')) //TODO: Find Systamatic way for handling this
        .unique();

      //console.log(types);
      let classes = types.map(createClass);
      classes.forEach(print);

      /* Create predicates */
      // ERROR: Could not resolve predicate predicate/2 (/path/to/lib.qll:r,c1-c2)
      let signatures = lines
        .filter(str => str.startsWith("ERROR: Could not resolve predicate "))
        .map(str => str.split(' ')[5])
        .unique();
      
      //console.log(signatures);
      let predicates = signatures.map(createPredicate);
      predicates.forEach(print);
    }
  });
}

function rewriteBody() {
  cp.exec(cmd, (err, stdout, stderr) => {
    if(err) {
      let lines = stderr.split('\n');

      /* Rename Types */
      // ERROR: Type is not compatible with MyType0_0 (/path/to/lib.qll:r,c1-c2)
      let replacePairs1 = lines
        .filter(str => str.includes(' is not compatible with MyType'))
        .map(str => str.split(' ')[6] + ':' + str.split(' ')[1])
        .unique();
      
      // ERROR: Type is incompatible with MyType0_0 (/path/to/lib.qll:r,c1-c2)
      let replacePairs2 = lines
        .filter(str => str.includes(' is incompatible with MyType'))
        .map(str => str.split(' ')[5] + ':' + str.split(' ')[1])
        .unique();
      
      // ERROR: MyType0_0 is not compatible with Type (/path/to/lib.qll:r,c1-c2)
      let replacePairs3 = lines
        .filter(str => str.includes('is not compatible with') && str.startsWith('ERROR: MyType'))
        .map(str => str.split(' ')[1] + ':' + str.split(' ')[6])
        .unique();

      //ERROR: Cannot determine result type of range with lower bound of type int, and upper bound of type MyType2. (/path/to/lib.qll:r,c1-c2)
      let replacePairs4 = lines
        .filter(str => str.startsWith('ERROR: Cannot determine result type of range with lower bound of type int, and upper bound of type MyType'))
        .map(str => str.split(' ')[18].slice(0,-1) + ':int')
        .unique();
     
      [
        ...replacePairs1,
        ...replacePairs2,
        ...replacePairs3,
        ...replacePairs4
      ].unique().forEach(replace);
      
      /* non-result predicates */
      // ERROR: Expected a predicate without result but found '(C.)predicate()', which is a predicate with result type 'int'. (/path/to/lib.qll:r,c1-c2)
      let purePredicates = lines
        .filter(str => str.startsWith('ERROR: Expected a predicate without result but found \''))
        .map(str => str.split('\'')[1].split('(')[0].split('.').last())
        .unique();

      purePredicates.forEach(toPurePredicate);

      /* Cleanup Primitives */
      origMerged = origMerged
        .filter(str => !str.startsWith('class MyType'))
        .map(str => str.replace(/\.as\w*(string|boolean|int)\(\)/, ''));
      
      /* append member predicates */
      // ERROR: predicate(int, string) cannot be resolved for type Class (/path/to/lib.qll:r,c1-c2)
      let missingMemberPredicates = lines
        .filter(str => str.includes(' cannot be resolved for type ') && !str.includes("MyType"))
        .map(str => str.split(')')[1].split(" ")[6] + '::' + str.split(')')[0].substring(7))
        .unique();
      
      //console.log(missingMemberPredicates);
      missingMemberPredicates.forEach(appendMemberPredicate);

      /* Manual cleanup */
      origMerged = origMerged.map(str =>
        str.replace(`as${Lang1}ParamNode()`, `as${Lang1}Node().(${LANG1}::ParamNode)`)
           .replace(`as${Lang2}ParamNode()`, `as${Lang2}Node().(${LANG2}::ParamNode)`)
      )

      origMerged.forEach(print);
    }
  });
}

let origMerged = "";

function main() {
  let stage = process.argv[2];
  if (!stage) {
    printHeader();
    printBody();
  }
  else if (stage == 1) {
    origMerged = readLines('dataflow/DataFlowmerged.qll');
    rewriteBody();
  }
  else if (stage == 2) {
    origMerged = readLines('dataflow/DataFlowmerged.qll');
    rewriteBody();
  }
  else {
    console.log('wrong arg');
  }
}

main();
