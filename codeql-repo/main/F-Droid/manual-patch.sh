while read line; do
  echo $line
  set $line
  sed "s/$2/$3/g" $1 > __tmp__
  mv __tmp__ $1
done < resource/manual-patch.txt
