root=${1:-"src"}
jcmd=${2:-"./gradlew -- --no-daemon clean assemble"}
ccmd=${3:-"make"}

echo '[Creating database for java]'
rm -rf db-java
echo '[init]'
codeql database init -l=java --source-root=$root db-java
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-java $jcmd

if [[ "$ccmd" == "abort" ]]; then
 exit 0
fi

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=$root db-cpp
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-cpp $ccmd
