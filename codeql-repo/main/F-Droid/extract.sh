if [ ! -d extracted ]; then
  mkdir extracted
fi

for file in download/*; do
  echo $file
  tar -xf $file -C extracted
done
