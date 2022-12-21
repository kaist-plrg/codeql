#!/bin/bash

set -e

ql="$CODEQL_HOME/lib-cpython/ql/pyobject.ql"

codeql query compile $ql

rm -rf pyobj-log
mkdir pyobj-log

for app in `ls $CODEQL_HOME/benchmark/cpython-large/db`; do
  if [ "$app" = "numpy" ]; then
    continue
  fi
  (
  echo "==========$app=========="
  db="$CODEQL_HOME/benchmark/cpython-large/db/$app"
  
  codeql database cleanup $db --mode=brutal

  st=`date +%s%3N`
  codeql query run $ql -d $db -j 0
  fn=`date +%s%3N`
  took=$((fn - st))
  echo "Took $took ms"
  ) | tee pyobj-log/$app
done
