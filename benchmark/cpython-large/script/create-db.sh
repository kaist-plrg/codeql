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
  cp resource/Makefile src/$app
  $CODEQL_HOME/script/cpython/create-db.sh src/$app db/$app | grep "Took"
done
