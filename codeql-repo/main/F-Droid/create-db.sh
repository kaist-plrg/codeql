prefix=""
cnt=0
ok=0

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
        cmd="./gradlew --no-daemon clean $task" ;;
      ant)
        cmd="ant clean debug" ;;
    esac
    
    rm -rf db-java
    codeql database create db-java -l java -c "$cmd"
    st=$?
    if [ $st -eq 130 ]; then #SIGINT
      exit 130
    elif [ $st -eq 0 ]; then
      rm -rf db-cpp
      codeql database create db-cpp -l cpp -c "$cmd"
      st=$?
      if [ $st -eq 130 ]; then #SIGINT
        exit 130
      elif [ $st -eq 0 ]; then
        (( ok+=1 ))
      fi
    fi
    
    cd $cur
  fi
done

echo $ok / $cnt
