while read line; do
  echo $line
  set $line
  sed "s/$2/$3/g" $1 > __tmp__
  mv __tmp__ $1
done < resource/manual-patch.txt

# Additional jobs
cd extracted/org.emunix.unipatcher_170200_src.tar.gz
cp ../../resource/gradlew .
cp ../../resource/gradle-wrapper.jar gradle/wrapper
./gradlew --no-daemon downloadDependencies 
cd ../..

cd extracted/org.geometerplus.zlibrary.ui.android_2050920_src.tar.gz/third-party/SuperToasts/
cp ../../local.properties .
cd ../../../..

cd extracted/org.tof_17_src
cp -r src-libs/tof/ jni
cd ../..
