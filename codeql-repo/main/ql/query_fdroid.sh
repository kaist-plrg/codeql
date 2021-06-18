set -e

codeql query compile $1

for d in `find ../db-fdroid -name db-merged` ; do
  echo $d
  codeql query run $1 -d $d/.. -j 0
done
