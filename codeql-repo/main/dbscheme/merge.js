const fs = require('fs');

// helpers
function read(filename) { return fs.readFileSync(filename); }
function readLines(filename) { return read(filename).toString().split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function writeLines(filename, lines) { write(filename, lines.join('\n')); }

// variables
const JS_DBSCHEME = "my.javascript.dbscheme";
const CPP_DBSCHEME = "my.cpp.dbscheme";
const JS_STAT = JS_DBSCHEME + ".stats";
const CPP_STAT = CPP_DBSCHEME + ".stats";
const MERGED_DBSCHEME = "my.merged.dbscheme";
const MERGED_STAT = MERGED_DBSCHEME + ".stats";

// dbscheme
var js_dbscheme = readLines(JS_DBSCHEME);
var cpp_dbscheme = readLines(CPP_DBSCHEME);
var idx = cpp_dbscheme.findIndex((l) => l.includes("sourceLocationPrefix"));
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
writeLines(MERGED_DBSCHEME, js_dbscheme.concat(cpp_dbscheme));

// dbscheme.stat
var js_stat = readLines(JS_STAT);
var cpp_stat = readLines(CPP_STAT);
/* TODO */
writeLines(MERGED_STAT, js_stat);
