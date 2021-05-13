if [[ $OSTYPE == linux-gnu* ]]; then
  ndk_old=ndk-old-linux.txt
elif [[ $OSTYPE == darwin* ]]; then
  ndk_old=ndk-old-darwin.txt
else
  echo "OS not supported"
  exit 1
fi

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
done < resource/$ndk_old

# install new ndks using sdkmanager
while read line; do
  echo $line
  set $line

  if [ -L ndk/$2 ]; then
    continue
  fi

  cmdline-tools/bin/sdkmanager --sdk_root=sdk --install "ndk;$1"
  ln -fs ../sdk/ndk/$1 ndk/$2
done < resource/ndk.txt
