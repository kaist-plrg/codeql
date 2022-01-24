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

function rewriteDBSchemes(dir, lang1, lang2, rewritter1, rewritter2) {
  console.log(`making new dbscheme in lib-${dir} by merging lib/${lang1} and lib/${lang2}`);

  // variables
  const DBSCHEME1 = walk(`lib/${lang1}`, 'dbscheme')[0];
  const DBSCHEME2 = walk(`lib/${lang2}`, 'dbscheme')[0];
  const STAT1 = DBSCHEME1 + ".stats";
  const STAT2 = DBSCHEME2 + ".stats";
  const DBSCHEME = `lib-${dir}/merged.dbscheme`;
  const STAT = DBSCHEME + ".stats";

  // dbscheme
  const dbscheme1 = readLines(DBSCHEME1);
  const dbscheme2 = readLines(DBSCHEME2);
  /*
  var lastOpen = -1;
  var startIdx, endIdx;
  for (let i = 0; i < cpp_dbscheme.length; ++i) {
    let l = cpp_dbscheme[i];
    if (l.startsWith("/**")) {
      lastOpen = i;
    }
    if (l.includes("sourceLocationPrefix")) {
      startIdx = lastOpen;
      endIdx = i;
      break;
    }
  }
  cpp_dbscheme.splice(startIdx, endIdx - startIdx + 1);
  */

  const new_dbscheme1 = dbscheme1.map(rewritter1);
  const new_dbscheme2 = dbscheme2.map(rewritter2);

  writeLines(DBSCHEME, new_dbscheme1.concat(new_dbscheme2));

  // dbscheme.stat
  const stat1 = readLines(STAT1);
  const stat2 = readLines(STAT2);
  /* TODO */
  const stat = stat2.map(l => {
    l = l.replaceAll("@", "@cpp_");
    if(l.includes("name") && !l.includes("sourceLocationPrefix"))
      return l.replace("<name>", "<name>cpp_");
    return l;
  });

  /* End Of TODO */
  writeLines(STAT, stat);
}

function javaRewritter(l) {
  l = l.replaceAll("@", "@java_");
  
  if(l.startsWith(" ") || l.startsWith("//") || l.startsWith("#") || !l.includes("("))
    return l;
  //if(l.includes("sourceLocationPrefix"))
    //return l;
  return 'java_' + l;
}

function cppRewritter(l) {
  l = l.replaceAll("@", "@cpp_");
  
  if(l.includes("sourceLocationPrefix"))
    return l;
  if(l.includes("(") && !l.split("(")[0].includes(" "))
    return 'cpp_' + l;
  return l;
}

function pythonRewritter(l) {
  l = l.replaceAll("@", "@python_");

  if(l.startsWith('xml')) // db whose name starts with xml is formatted this way
    return 'python_' + l;
  if(l.includes("(") && !l.split("(")[0].includes(" "))
    return 'python_' + l;
  return l;
}

rewriteDBSchemes("jni", "java", "cpp", javaRewritter, cppRewritter);
rewriteDBSchemes("cpython", "python", "cpp", pythonRewritter, cppRewritter);
