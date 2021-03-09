const fs = require('fs');

// helpers
function read(filename) { return fs.readFileSync(filename); }
function readLines(filename) { return read(filename).toString().split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function writeLines(filename, lines) { write(filename, lines.join('\n')); }
function readModifyWrite(from, to, ...funcs) {
  let oldLines = readLines(from);
  let newLines = funcs.reduce((lines, func) => lines.map(func), oldLines);
  writeLines(to, newLines);
}

// variables
var from = "";
var to = "";
const PREFIX = "js_";
var typePrefixAdder = str => str.replaceAll("@", "@"+PREFIX);

// dbscheme
from = "semmlecode.javascript.dbscheme"
to = "my.javascript.dbscheme"

readModifyWrite(from, to,
  l => {
    if(l.startsWith(" ") || l.startsWith("//") || l.startsWith("#") || !l.includes("("))
      return l;
    if(l.includes("sourceLocationPrefix"))
      return l;
    return PREFIX + l;
  },
  typePrefixAdder
);

// dbsccheme.stat
from += ".stats";
to += ".stats";

readModifyWrite(from, to,
  l => {
    if(l.includes("sourceLocationPrefix"))
      return l;
    if(l.includes("name"))
      return l.replace("<name>", "<name>"+PREFIX);
    return l;
  },
  typePrefixAdder
);
