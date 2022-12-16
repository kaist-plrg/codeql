while read line; do
  set $line
  app=$1
  v=$2
  cd src/$app
  git checkout -- .
  git checkout $v
  cd ../..
done < resource/commit.txt
