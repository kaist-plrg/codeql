const fs = require('fs');
const copydir = require('copy-dir');
 
// helpers
function read(filename) { return fs.readFileSync(filename).toString(); }
function readLines(filename) { return read(filename).split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
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

function rewriteLib(dir, language) {
  console.log(`[${language}]`);

  // Extract relation names, using *.dbscheme.stats file
  console.log("extracting relation names..");
  let orig_stat = walk(`lib/${language}`, 'stats')[0];
  let rels = readLines(orig_stat)
    .filter(l=>l.includes("<name>") && !l.includes('sourceLocationPrefix'))
    .map(l=>l.substring(6, l.length-7))

  const ORIG_LIB_DIR = `lib/${language}/ql/lib`;
  const MY_LIB_DIR = `lib-${dir}/${language}`;
  const PREFIX = `${language}_`;

  // copy library
  console.log("copying library..");
  fs.mkdirSync(MY_LIB_DIR, { recursive: true })
  fs.rmSync(MY_LIB_DIR, { recursive: true, force: true });
  copydir.sync(ORIG_LIB_DIR, MY_LIB_DIR);

  // rewrite
  console.log("rewritting..");
  walk(MY_LIB_DIR, ".qll").forEach(file => {
    var content = read(file);
    var rewritten = rels
      .reduce((cur_content, rel) => {
        let pattern = RegExp(`(?<!predicate) ${rel}\\((?!\\))`, 'g');
        return cur_content.replaceAll(pattern, ` ${PREFIX}${rel}(`);
      }, content)
      .replaceAll("@", "@"+PREFIX);
    
      if (language == 'java') {
      /*
      if (file.endsWith('Modifier.qll')) {
        rewritten = rewritten.replaceAll("java_hasModifier(\"","hasModifier(\"");
      }
      if (file.endsWith('DataFlowPrivate.qll')) {
        rewritten = rewritten.replace("private class FieldContent ","class FieldContent ");
      }
      if (file.endsWith('DataFlowUtil.qll')) {
        rewritten = rewritten.replace("private class NewExpr ","class NewExpr ");
      }
      */
    }

    if (language == 'python') {
      if (file.endsWith('Exprs.qll')) {
        rewritten = rewritten.replaceAll("(py_cobjecttypes","(python_py_cobjecttypes");
      }
    }

    write(file, rewritten);
  })

  console.log();
}

/* JNI */
console.log('==========jni============');
rewriteLib('jni', 'java');
rewriteLib('jni', 'cpp');

/* c-python */
console.log('==========cpython========');
rewriteLib('cpython', 'python');
rewriteLib('cpython', 'cpp');
