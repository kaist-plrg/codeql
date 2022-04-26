set -e

rm -rf db
mkdir db

for app in `ls src`; do
  echo "========$app========"
  $CODEQL_HOME/script/cpython/create-db.sh src/$app db/$app
done
