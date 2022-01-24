let rel = "rel";
let PREFIX = "python_";

let pattern = RegExp(`(?<!predicate)\\W${rel}\\((?!\\))`, 'g');

let line = "(rel(1,2) or rel(2,3))";

console.log(line.replaceAll(pattern, ` ${PREFIX}${rel}(`));
console.log(`(?<!predicate)\\W${rel}\\((?!\\))`);
