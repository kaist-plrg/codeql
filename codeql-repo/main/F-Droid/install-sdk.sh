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
