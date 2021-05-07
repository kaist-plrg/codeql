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
Array.prototype.last = function(){ return this[this.length - 1]; };

var from;
var to;
var lines;
var newLines;

const EXTRACTED = "extracted";
const SDK_DIR = process.env.PWD + "/sdk";
const NDK_DIR = process.env.PWD + "/ndk";

walk(EXTRACTED, "local.properties").forEach(from => {
  to = from;
  bak = from + ".bak";
  lines = readLines(from);
  newLines = lines.map(line => {
    if(line.startsWith("sdk")) {
      prefix = line.split("=")[0];
      return `${prefix}=${SDK_DIR}`;
    }
    if(line.startsWith("ndk")) {
      tokens = line.split("=");
      prefix = tokens[0];
      suffix = tokens[1].split("/").last();
      return `${prefix}=${NDK_DIR}/android-ndk-${suffix}`;
    }
    return line;
  });
  writeLines(to, newLines);
  writeLines(bak, lines);
});
