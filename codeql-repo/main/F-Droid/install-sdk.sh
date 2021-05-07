pVersions=`grep compileSdkVersion -r extracted --include build.gradle -h | grep -Eo "\d\d" | sort -u`
btVersions=`grep buildToolsVersion -r extracted --include build.gradle -h | grep -Eo "\d\d\.\d\.\d" | sort -u`

alias sdkmanager="cmdline-tools/bin/sdkmanager --sdk_root=sdk"
cmd="sdkmanager"

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
