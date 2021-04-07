root=NativeFlowBench

cd $root
./gradlew clean > /dev/null 2> /dev/null
cd ..

echo '[Creating database for java]'
rm -rf db-java
echo '[init]'
codeql database init -l=java --source-root=$root db-java
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-java ./gradlew -- --no-daemon compileDebugJavaWithJavac

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=$root db-cpp
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-cpp ./gradlew -- externalNativeBuildDebug
