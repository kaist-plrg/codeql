root=$1
db=$2
jcmd=$3
ccmd=$4

scriptDir=$CODEQL_HOME/script/jni

$scriptDir/trap.sh $root "$jcmd" "$ccmd"
$scriptDir/merge.sh $root $db
