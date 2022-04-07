root=${1:-"src"}

echo '[Creating database for python]'
rm -rf db-python
echo '[init]'
codeql database init -l=python --source-root=$root db-python
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-python --index-traceless-dbs

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=$root db-cpp
echo '[trace-command]'
(cd $root; make clean)
codeql database trace-command --working-dir=$root db-cpp make
