root=${1:-"jni"}

echo '[Creating database for java]'
rm -rf db-java
echo '[init]'
codeql database init -l=java --source-root=$root db-java
echo '[trace-command]'
#codeql database trace-command --working-dir=$root db-java "$CODE_QL_HOME/codeql/java/tools/autobuild.sh"
codeql database trace-command --working-dir=$root db-java gradle -- clean assemble

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=$root db-cpp
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-cpp make
