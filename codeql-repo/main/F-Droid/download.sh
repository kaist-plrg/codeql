while read line; do
  echo $line
  wget -P download $line
done < resource/src.txt
