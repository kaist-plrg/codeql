while read line; do
  set $line

  mkdir -p $1/gradle/wrapper
  
  echo distributionUrl=https\\://services.gradle.org/distributions/gradle-$3-bin.zip \
  > $1/gradle/wrapper/gradle-wrapper.properties

  if [ "$4" == CP_LOCAL_PROPERTIES ]; then
    cp $1/../local.properties $1
  elif [ "$4" == MAVEN_CENTRAL ]; then
    sed 's/mavenCentral()/maven { url "https:\/\/repo1.maven.org\/maven2\/" }/g' $1/build.gradle > __tmp__
    mv __tmp__ $1/build.gradle
  elif [ ! -z "$4" ]; then
    sed 's/3.0.1/3.1.1/g' $1/build.gradle > __tmp__
    mv __tmp__ $1/build.gradle
  fi
done < resource/gradle-version-patch.txt
