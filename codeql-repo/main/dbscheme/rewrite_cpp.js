const fs = require('fs');

// helpers
function read(filename) { return fs.readFileSync(filename); }
function readLines(filename) { return read(filename).toString().split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function writeLines(filename, lines) { write(filename, lines.join('\n')); }
function read_modify_write(from, to, ...funcs) {
  let oldLines = readLines(from);
  let newLines = funcs.reduce((lines, func) => lines.map(func), oldLines);
  writeLines(to, newLines);
}

// variables
var from = "";
var to = "";
const PREFIX = "cpp_";
var typePrefixAdder = str => str.replaceAll("@", "@"+PREFIX);

// dbscheme
from = "semmlecode.cpp.dbscheme"
to = "my.cpp.dbscheme"

read_modify_write(from, to,
  l => {
    if(l.includes("sourceLocationPrefix"))
      return l;
    if(l.includes("(") && !l.split("(")[0].includes(" "))
      return PREFIX + l;
    return l;
  },
  typePrefixAdder
)

// dbsccheme.stat
from += ".stats";
to += ".stats";

read_modify_write(from, to,
  l => {
    if(l.includes("name") && !l.includes("sourceLocationPrefix"))
      return l.replace("<name>", "<name>"+PREFIX);
    return l;
  },
  typePrefixAdder
)
