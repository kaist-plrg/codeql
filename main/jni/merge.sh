root=${1:-"src"}
db=${2:-"db-merged"}

mkdir -p $db
rm -rf $db
codeql database init -l=jni --source-root=$root $db
mkdir $db/src
node rewrite-trap.js $db
codeql database finalize --dbscheme="../../lib-jni/merged.dbscheme" $db
