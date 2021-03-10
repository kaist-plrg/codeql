const fs = require('fs');
const zlib = require('zlib');
const path = require('path');
const tar = require('tar');

// helpers
function read(filename) { return fs.readFileSync(filename); }
function readLines(filename) { return read(filename).toString().split('\n'); }
function readLines_gz(filename) { return zlib.gunzipSync(read(filename)).toString().split('\n'); }
function readLines_br(filename) { return zlib.brotliDecompressSync(read(filename)).toString().split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function write_gz(filename, data) { write(filename, zlib.gzipSync(data)); }
function write_br(filename, data) { write(filename, zlib.brotliCompressSync(data)); }
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
function createParentDir(filePath) {
  let dirPath = path.dirname(filePath);
  fs.mkdirSync(dirPath, {recursive: true});
}
Array.prototype.last = function(){ return this[this.length - 1]; };


var from;
var to;
var lines;
var rewritten;

const JAVA_PREFIX = "java_";
const CPP_PREFIX = "cpp_";
const JAVA_DIR = "db-java/trap/java";
const CPP_DIR = "db-cpp/trap/cpp";
const MERGED_DIR = "db-merged/trap/merged";

function rewriteLine(PREFIX) {
  return l => {
    if(l === "" || l.startsWith("/") || l.startsWith("#"))
      return l;
    if(!l.includes("("))
      return l;
    return PREFIX + l
  };
}

// java
walk(JAVA_DIR, ".trap.gz").forEach(from => {
  to = from.replace(JAVA_DIR, MERGED_DIR);
  lines = readLines_gz(from);
  rewritten = lines.map(rewriteLine(JAVA_PREFIX));
  createParentDir(to);
  write_gz(to, rewritten.join("\n"));
});

// cpp

/// compile trap
from = walk(CPP_DIR + '/compilations','.br')[0];
to = from.replace(CPP_DIR, MERGED_DIR);
lines = readLines_br(from);
rewritten = lines.map(rewriteLine(CPP_PREFIX));
createParentDir(to);
write_br(to, rewritten.join("\n"));

/// source trap
var tar_br = walk(CPP_DIR + '/tarballs','.br')[0];
var tar_content = readLines_br(tar_br);
write('temp.tar', tar_content.join('\n'));
if(!fs.existsSync('temp'))
  fs.mkdirSync('temp');
tar.x({file: 'temp.tar', cwd: 'temp', sync: true});

walk('temp','.trap').forEach(from => {
  to = from;
  lines = readLines(from);
  rewritten = lines.map(rewriteLine(CPP_PREFIX));
  write(to, rewritten.join("\n"));
});

tar.c({file: 'temp.tar', cwd:'temp', sync: true}, fs.readdirSync('temp'));
var new_tar_content = readLines('temp.tar');
var new_tar_br = tar_br.replace(CPP_DIR, MERGED_DIR);
createParentDir(new_tar_br);
write_br(new_tar_br, new_tar_content.join("\n"));

fs.unlinkSync('temp.tar');
fs.rmdirSync('temp', {recursive:true});

// manifest
from = tar_br + ".manifest";
to = new_tar_br + ".manifest";
write(to,read(from).toString());
