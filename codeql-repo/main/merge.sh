root=${1:-"jni"}
db=${2:-"db-merged"}

mkdir -p $db
rm -rf $db
codeql database init -l=merged --source-root=$root $db
mkdir $db/src
node rewrite-trap.js $db
codeql database finalize --dbscheme=dbscheme/my.merged.dbscheme $db
