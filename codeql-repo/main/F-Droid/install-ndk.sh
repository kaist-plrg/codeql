# install old ndks by manually downloading from url
while read line; do
  echo $line
  set $line
  
  if [ -d ndk/$2 ]; then
    continue
  fi
    
  zip=__tmp__.zip
  wget -O $zip $1
  unzip -n -q $zip -d ndk
  rm $zip
done < ndk-old.txt

# install new ndks using sdkmanager
while read line; do
  echo $line
  set $line

  if [ -L ndk/$2 ]; then
    continue
  fi

  scmdline-tools/bin/sdkmanager --sdk_root=sdk --install "ndk;$1"
  ln -fs ../sdk/ndk/$1 ndk/$2
done < ndk.txt
