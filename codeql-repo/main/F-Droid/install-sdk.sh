pVersions=`grep compileSdkVersion -r extracted --include build.gradle -h | grep -o "[0-9][0-9]" | sort -u`
btVersions=`grep buildToolsVersion -r extracted --include build.gradle -h | grep -o "[0-9][0-9]\.[0-9]\.[0-9]" | sort -u`

#org.zamedev.gloomydungeons
pVersions+=" 17"
btVersions+=" 19.1.0"

cmd="cmdline-tools/bin/sdkmanager --sdk_root=sdk"

for version in $pVersions; do
  echo $version
  cmd+=" \"platforms;android-$version\""
done

for version in $btVersions; do
  echo $version
  cmd+=" \"build-tools;$version\""
done

echo $cmd
eval $cmd

# install ant script
if [ -d sdk/tools/ant ]; then
  exit 0
fi

if [[ $OSTYPE == linux-gnu* ]]; then
  url=https://dl.google.com/android/repository/tools_r25.2.5-linux.zip
elif [[ $OSTYPE == darwin* ]]; then
  url=https://dl.google.com/android/repository/tools_r25.2.5-macosx.zip
else
  echo "OS not supported"
  exit 1
fi

zip=__tmp__.zip
wget -O $zip $url
unzip -n -q $zip
cp -n -r tools sdk
rm -r tools
rm $zip
