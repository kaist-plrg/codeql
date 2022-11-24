set -e

rm -rf log
mkdir log

query="$CODEQL_HOME/lib-cpython/ql/polycruise.ql"

codeql query compile $query

for app in `ls src`; do
  (
    echo "========$app========"; 
    codeql query run $query -d db/$app
  ) | tee log/$app
done
