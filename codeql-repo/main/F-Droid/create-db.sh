prefix=""
cnt=0
ok=0

rm -f resource/success.txt

for d in `find extracted -type d`; do
  if [ ! -z $prefix ] && [[ $d == $prefix* ]]; then
    continue
  fi
  if [[ $d == *xcsoar* ]] || [[ $d == *Externals* ]] || [[ $d == *third-party* ]]; then
    continue
  fi
  
  build=""
  if [ -f $d/build.gradle ]; then
    build=gradle
  elif [ -f $d/project.properties ] && [ -f $d/build.xml ]; then
    build=ant
  fi

  if [ ! -z $build ]; then
    echo ===============================
    echo $d
    echo ===============================
    prefix=$d

    (( cnt+=1 ))

    if [ "$build" == gradle ]; then
      cp gradlew $d
      if [ ! -d $d/gradle/wrapper ]; then
        mkdir -p $d/gradle/wrapper
      fi
      cp gradle-wrapper.jar $d/gradle/wrapper
    fi
    
    cur=$PWD
    cd $d

    case $build in
      gradle)
        task=`./gradlew --no-daemon task | grep -m 1 compile.*DebugSources`
        st=$?
        if [ $st -eq 130 ]; then #SIGINT
          exit 130
        fi
        if [ ! $st -eq 0 ]; then
          cd $cur
          continue
        fi
        clean="./gradlew --no-daemon clean"
        ccmd="./gradlew --no-daemon $task"
        jcmd="./gradlew --no-daemon clean $task" ;;
      ant)
        clean="ant clean"
        ccmd="ant debug"
        jcmd="ant clean debug" ;;
    esac

    ndk-build -n > /dev/null 2> /dev/null
    if [ $? -eq 0 ]; then
      jcmd=$ccmd
      ccmd="ndk-build -B"
    fi

    success=0
    
    $clean

    rm -rf db-cpp
    codeql database create db-cpp -l cpp -c "$ccmd"
    st=$?
    if [ $st -eq 130 ]; then #SIGINT
      exit 130
    elif [ $st -eq 0 ]; then
      rm -rf db-java
      codeql database create db-java -l java -c "$jcmd"
      st=$?
      if [ $st -eq 130 ]; then #SIGINT
        exit 130
      elif [ $st -eq 0 ]; then
        success=1
      fi
    fi
    
    cd $cur
  
    if [ $success -eq 1 ]; then
      (( ok += 1 ))
      echo $d ";" $clean ";" $ccmd ";" $jcmd >> resource/success.txt
    fi
  fi
done

echo $ok / $cnt
