if [[ $OSTYPE == linux-gnu* ]]; then
  url=https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip
elif [[ $OSTYPE == darwin* ]]; then
  url=https://dl.google.com/android/repository/commandlinetools-mac-7302050_latest.zip
else
  echo "OS not supported"
  exit 1
fi

zip=__tmp__.zip
wget -O $zip $url
unzip -n -q $zip
rm $zip
