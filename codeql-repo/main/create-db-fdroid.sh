set -e

lines=()

while read line; do
  lines+=( "$line" )
done < F-Droid/resource/success.txt

for line in "${lines[@]}"; do
  d=F-Droid/`echo $line | cut -d ";" -f 1`
  clean=`echo $line | cut -d ";" -f 2`
  ccmd=`echo $line | cut -d ";" -f 3`
  jcmd=`echo $line | cut -d ";" -f 4`
  echo "===================="
  echo $d
  echo "===================="

  if [ -f build.gradle ]; then
    #gradle
    cp F-Droid/gradlew $d
    if [ ! -d $d/gradle/wrapper ]; then
      mkdir -p $d/gradle/wrapper
    fi
    cp F-Droid/gradle-wrapper.jar $d/gradle/wrapper
  fi
  
  (cd $d ; $clean)

  echo '[Creating database for cpp]'
  rm -rf db-cpp
  echo ' [init]'
  codeql database init -l cpp --source-root $d db-cpp
  echo ' [trace-command]'
  codeql database trace-command --working-dir $d db-cpp $ccmd
  
  echo '[Creating database for java]'
  rm -rf db-java
  echo ' [init]'
  codeql database init -l java --source-root $d db-java
  echo ' [trace-command]'
  codeql database trace-command --working-dir $d db-java $jcmd

  dbdir=`echo $d | sed "s/F-Droid\/extracted/db-fdroid/g"`
  ./merge.sh $d $dbdir
done
