set -e

lines=( )

while read line; do
  lines+=( "$line" )
done < F-Droid/resource/success.txt

export PATH="$CODE_QL_HOME/codeql-repo/main/F-Droid/resource:$PATH"
while read line; do
  lines+=( "$line" )
done < F-Droid/resource/manual-success.txt

rm -rf time.txt

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
  prev=`date +%s%N`
  codeql database trace-command --working-dir $d db-cpp $ccmd
  cur=`date +%s%N`
  (( cpp_time = (cur - prev)/1000000 ))

  echo '[Creating database for java]'
  rm -rf db-java
  echo ' [init]'
  codeql database init -l java --source-root $d db-java
  echo ' [trace-command]'
  prev=`date +%s%N`
  codeql database trace-command --working-dir $d db-java $jcmd
  cur=`date +%s%N`
  (( java_time = (cur - prev)/1000000 ))

  dbdir=`echo $d | sed "s/F-Droid\/extracted/db-fdroid/g"`
  prev=`date +%s%N`
  ./merge.sh $d $dbdir
  cur=`date +%s%N`
  (( merge_time = (cur - prev)/1000000 ))

  echo $d $cpp_time $java_time $merge_time >> time.txt
done
