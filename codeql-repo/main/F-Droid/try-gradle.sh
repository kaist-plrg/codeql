#set -e

prefix=""
cnt=0
ok=0

for d in `find extracted -type d`; do
  if [ ! -z $prefix ] && [[ $d == $prefix* ]]; then
    continue
  fi
  if [ -f $d/build.gradle ]; then
    echo ===============================
    echo $d
    echo ===============================
    prefix=$d

    (( cnt+=1 ))

    cp gradlew $d
    if [ ! -d $d/gradle/wrapper ]; then
      mkdir -p $d/gradle/wrapper
    fi
    cp gradle-wrapper.jar $d/gradle/wrapper
    
    cur=$PWD
    cd $d
    # run gradle wrapper
    ./gradlew --no-daemon
    st=$?
    if [ $st -eq 130 ]; then #SIGINT
      exit 130
    fi
    if [ $st -eq 0 ]; then
      (( ok+=1 ))
    fi
    cd $cur
  fi
done

echo $ok / $cnt
