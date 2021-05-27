#Exit if any command fails
set -e

codeql query compile $1

for d in ../db-native/* ; do
  echo $d
  codeql query run $1 -d $d
done
