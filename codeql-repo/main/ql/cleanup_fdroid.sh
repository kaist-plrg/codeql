set -e

for d in `find ../db-fdroid -name db-merged` ; do
  echo $d
  codeql database cleanup $d/.. -m brutal
done
