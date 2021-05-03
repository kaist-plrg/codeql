set -e

root=NativeFlowBench

apps=(
  "icc_javatonative"
  "icc_nativetojava"
  "native_complexdata"
  "native_complexdata_stringop"
  "native_dynamic_register_multiple"
  "native_heap_modify"
  "native_leak"
  "native_leak_array"
  "native_leak_dynamic_register"
  "native_method_overloading"
  "native_multiple_interactions"
  "native_multiple_libraries"
  "native_noleak"
  "native_noleak_array"
  "native_nosource"
  "native_pure"
  "native_pure_direct"
  "native_pure_direct_customized"
  "native_set_field_from_arg"
  "native_set_field_from_arg_field"
  "native_set_field_from_native"
  "native_source"
  "native_source_clean"
)

rm -rf db-native
mkdir db-native

# Extract common libraries
echo '[Creating database for java library]'
rm -rf db-java-lib
echo '[init]'
codeql database init -l=java --source-root=$root db-java-lib
echo '[trace-command]'
codeql database trace-command --working-dir=$root db-java-lib ./gradlew -- \
  --no-daemon :native_noleak:clean native_noleak:compileDebugJavaWithJavac

echo '[Executing clean build]'
cd $root
./gradlew clean > /dev/null 2> /dev/null
cd ..

for app in ${apps[@]}; do
  echo "========$app========"

  echo '[Creating database for java]'
  rm -rf db-java
  echo '[init]'
  codeql database init -l=java --source-root=$root db-java
  echo '[trace-command]'
  codeql database trace-command --working-dir=$root db-java ./gradlew -- --no-daemon :$app:compileDebugJavaWithJavac

  echo '[Creating database for cpp]'
  rm -rf db-cpp
  echo '[init]'
  codeql database init -l=cpp --source-root=$root db-cpp
  echo '[trace-command]'
  codeql database trace-command --working-dir=$root db-cpp ./gradlew -- :$app:externalNativeBuildDebug

  ./merge.sh NativeFlowBench/$app db-native/$app 
done
