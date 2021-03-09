rm -rf db-merged
codeql database init -l=merged --source-root=src db-merged
mkdir db-merged/src
node rewrite-trap.js
codeql database finalize --dbscheme=dbscheme/my.merged.dbscheme db-merged
