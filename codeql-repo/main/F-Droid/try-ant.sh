prefix=""
cnt=0
ok=0

for d in `find extracted -type d`; do
  if [ ! -z $prefix ] && [[ $d == $prefix* ]]; then
    continue
  fi

  if [[ $d == *xcsoar* ]]; then
    continue
  fi
  
  if [ -f $d/build.gradle ]; then
    prefix=$d
  elif [ -f $d/project.properties ] && [ -f $d/build.xml ]; then
    echo ===============================
    echo $d
    echo ===============================
    prefix=$d
    
    cur=$PWD
    cd $d
    ant clean
    ant debug
    st=$?
    if [ $st -eq 130 ]; then #SIGINT
      exit 130
    elif [ $st -eq 0 ]; then
      (( ok+=1 ))
    fi
    cd $cur

    (( cnt+=1 ))
  fi
done

echo $ok / $cnt
