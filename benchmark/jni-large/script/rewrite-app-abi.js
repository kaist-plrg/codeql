const fs = require('fs');

// helpers
function read(filename) { return fs.readFileSync(filename); }
function readLines(filename) { return read(filename).toString().split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function writeLines(filename, data) { fs.writeFileSync(filename, data.join('\n')); }
function walk(dir, ext) {
    var results = [];
    var list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = dir + '/' + file;
        var stat = fs.statSync(file, {throwIfNoEntry: false});
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

var from;
var to;
var lines;
var newLines;

walk("extracted", "Application.mk").forEach(from => {
  console.log(from);
  to = from;
  lines = readLines(from);
  newLines = lines.map(line => {
    if(line.startsWith("APP_ABI"))
      return "APP_ABI := armeabi-v7a";
    return line;
  });
  writeLines(to, newLines);
});
