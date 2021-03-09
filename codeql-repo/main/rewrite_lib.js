const fs = require('fs');
const copydir = require('copy-dir');
 
// helpers
function read(filename) { return fs.readFileSync(filename).toString(); }
function readLines(filename) { return read(filename).split('\n'); }
function write(filename, data) { fs.writeFileSync(filename, data); }
function walk(dir) {
    var results = [];
    var list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = dir + '/' + file;
        var stat = fs.statSync(file);
        if (stat && stat.isDirectory()) { 
            /* Recurse into a subdirectory */
            results = results.concat(walk(file));
        } else if (file.endsWith('.qll')) {
            /* Is a file */
            results.push(file);
        }
    });
    return results;
}

// Extract relation names
console.log("extracting..");
var orig_stat = "semmlecode.javascript.dbscheme.stats";
var rels = readLines(orig_stat)
  .filter(l=>l.includes("<name>") && !l.includes('sourceLocationPrefix'))
  .map(l=>l.substring(6, l.length-7))

var ORIG_LIB_DIR = '../ql';
var MY_LIB_DIR = '../myql';
var PREFIX = 'js_';

// copy library
console.log("copying..");
fs.rmdirSync(MY_LIB_DIR, {recursive: true});
copydir.sync(ORIG_LIB_DIR, MY_LIB_DIR);

// rewrite
console.log("rewritting..");
walk(MY_LIB_DIR + '/src').forEach(file => {
  var content = read(file);
  var rewritten = rels.reduce((cur_content, rel) => {
    return cur_content.replaceAll(` ${rel}(`, ` ${PREFIX}${rel}(`);
  }, content);
  write(file, rewritten);
})
