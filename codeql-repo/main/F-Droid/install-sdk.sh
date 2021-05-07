pVersions=`grep compileSdkVersion -r extracted --include build.gradle -h | grep -o "[0-9][0-9]" | sort -u`
btVersions=`grep buildToolsVersion -r extracted --include build.gradle -h | grep -o "[0-9][0-9]\.[0-9]\.[0-9]" | sort -u`

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
