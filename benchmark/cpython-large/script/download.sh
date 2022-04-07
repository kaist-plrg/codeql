while read line; do
  echo $line
  git clone $line
done < resource/origin.txt
