echo '[Creating database for java]'
rm -rf db-java
echo '[init]'
codeql database init -l=java --source-root=jni db-java
echo '[trace-command]'
codeql database trace-command --working-dir=jni db-java "$CODE_QL_HOME/codeql/java/tools/autobuild.sh"

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=jni db-cpp
echo '[trace-command]'
codeql database trace-command --working-dir=jni db-cpp make
