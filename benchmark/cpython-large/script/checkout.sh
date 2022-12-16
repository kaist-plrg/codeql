while read line; do
  tokens=($line)
  app=${tokens[0]}
  v=${tokens[1]}
  cd src/$app
  git checkout $v
  cd ../..
done < resource/commit.txt
