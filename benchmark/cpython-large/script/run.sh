set -e

rm -rf log
mkdir log

query="$CODEQL_HOME/lib-cpython/ql/security.ql"

codeql query compile $query

apps=(
  "bitarray"
  "bounter"
  "cvxopt"
  "distance"
  "immutables"
  "japronto"
  "noise"
  "pyahocorasick"
  "pyo"
  "python-Levenshtein"
  "python-llist"
  "simplejson"
  "numpy"
)

#for app in `ls $CODEQL_HOME/benchmark/cpython-large/db`; do
for app in ${apps[@]}; do
  db="$CODEQL_HOME/benchmark/cpython-large/db/$app"

  (
  echo "==========$app=========="
  #codeql database cleanup $db --mode=brutal
  st=`date +%s`
  codeql query run $query -d $db -j 0
  fn=`date +%s`
  took=$((fn - st))
  echo "Took $took s"
  ) | tee log/$app
done
