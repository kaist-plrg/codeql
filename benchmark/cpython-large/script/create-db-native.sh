set -e

apps=(
  "bitarray"
  "distance"
  "noise"
  "pyahocorasick"
  "python-Levenshtein"
  "python-llist"
)

rm -rf db
mkdir db

for app in ${apps[@]}; do
  echo "========$app========"
  cp resource/Makefile $app
  $CODEQL_HOME/script/create-cpython-db.sh $app db/$app
done
