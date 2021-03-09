echo '[Creating database for js]'
rm -rf db-js
echo '[init]'
codeql database init -l=javascript --source-root=src db-js
echo '[trace-command]'
codeql database trace-command --working-dir=src db-js $CODE_QL_HOME/codeql/javascript/tools/autobuild.sh

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=src db-cpp
echo '[trace-command]'
codeql database trace-command --working-dir=src db-cpp make
