codeql query compile ql/pyobject.ql

for app in `ls $CODEQL_HOME/benchmark/cpython-large/db`; do
  echo "==========$app=========="
  
  db="$CODEQL_HOME/benchmark/cpython-large/db/$app"
  
  codeql database cleanup $db --mode=brutal

  st=`date +%s%3N`
  codeql query run ql/pyobject.ql -d $db -j 0
  fn=`date +%s%3N`
  took=$((fn - st))
  echo "Took $took ms"
done
