root=${1:-"src"}
db=${2:-"db-merged"}

mkdir -p $db
rm -rf $db
codeql database init -l=jni --source-root=$root $db
mkdir $db/src
node $CODEQL_HOME/script/jni/rewrite-trap.js $db
rm -rf db-java
rm -rf db-java-lib
rm -rf db-cpp
codeql database finalize --dbscheme="$CODEQL_HOME/lib-jni/merged.dbscheme" $db
