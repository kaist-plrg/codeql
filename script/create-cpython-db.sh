root=$1
db=$2

script=$CODEQL_HOME/script

$script/trap.sh $root
$script/merge.sh $root $db
