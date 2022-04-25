set -e

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

rm -rf db
mkdir db

script="$CODEQL_HOME/script/jni"

echo '[Extracting common library for java]'
$script/trap.sh src \
  "./gradlew -- --no-daemon :native_noleak:clean native_noleak:compileDebugJavaWithJavac" \
  "abort"
mv db-java db-java-lib

echo '[Executing clean build]'
(cd src; ./gradlew --no-daemon clean > /dev/null 2> /dev/null)

for app in ${apps[@]}; do
  echo "========$app========"
  $script/create-db.sh src db/$app\
    "./gradlew -- --no-daemon :$app:compileDebugJavaWithJavac"\
    "./gradlew -- --no-daemon :$app:externalNativeBuildDebug"
done
