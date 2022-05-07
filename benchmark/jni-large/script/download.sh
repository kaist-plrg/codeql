while read line; do
  echo $line
  wget -P download $line
  if [[ $? != 0 ]]; then
    echo $line >> fail3
  fi
done < fail2
#resource/src.txt
