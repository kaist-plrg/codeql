root=${1:-"src"}
db=${2:-"db-merged"}

st=`date +%s%3N`

mkdir -p $db
rm -rf $db
codeql database init -l=cpython --source-root=$root $db
mkdir $db/src
node $CODEQL_HOME/script/cpython/rewrite-trap.js $db
rm -rf db-python
rm -rf db-cpp
codeql database finalize --dbscheme="$CODEQL_HOME/lib-cpython/merged.dbscheme" $db

fn=`date +%s%3N`
took=$((fn - st))
echo "Took $took ms for merged"
