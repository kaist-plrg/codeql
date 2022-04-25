root=$1
db=$2

scriptDir=$CODEQL_HOME/script/cpython

$scriptDir/trap.sh $root
$scriptDir/merge.sh $root $db
