rm -rf src
mkdir src

while read line; do
  echo $line
  cd src
  git clone $line
  cd ..
done < resource/origin.txt
