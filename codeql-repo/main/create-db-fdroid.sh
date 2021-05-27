set -e

#rm -rf db-fdroid
#mkdir db-fdroid

dirs=()

while read line; do
  dirs+=( $line )
done < F-Droid/resource/success.txt

for d in ${dirs[@]}; do
  echo "===================="
  echo $d
  echo "===================="

  cur=$PWD
  cd F-Droid/$d

  if [ -f build.gradle ]; then
    #gradle
    cp $cur/F-Droid/gradlew .
    if [ ! -d gradle/wrapper ]; then
      mkdir -p gradle/wrapper
    fi
    cp $cur/F-Droid/gradle-wrapper.jar gradle/wrapper
    task=`./gradlew --no-daemon task | grep -m 1 compile.*DebugSources`
    cmd="./gradlew --no-daemon clean $task"
  else
    #ant
    cmd="ant clean debug" 
  fi

  cd $cur

  echo '[Creating database for java]'
  rm -rf db-java
  echo ' [init]'
  codeql database init -l=java --source-root=F-Droid/$d db-java
  echo ' [trace-command]'
  codeql database trace-command --working-dir=F-Droid/$d db-java $cmd

  echo '[Creating database for cpp]'
  rm -rf db-cpp
  echo ' [init]'
  codeql database init -l=cpp --source-root=F-Droid/$d db-cpp
  echo ' [trace-command]'
  codeql database trace-command --working-dir=F-Droid/$d db-cpp $cmd

  dbdir=`echo $d | sed "s/extracted/db-fdroid/g"`
  ./merge.sh F-Droid/$d $dbdir
done
