while read line; do
  set $line

  mkdir -p $1/gradle/wrapper
  
  sed "s/$2/$3/g" $1/build.gradle > $1/build.gradle.new
  mv $1/build.gradle.new $1/build.gradle
  
  echo distributionUrl=https\\://services.gradle.org/distributions/gradle-$4-bin.zip \
  > $1/gradle/wrapper/gradle-wrapper.properties
done < gradle-version-patch.txt
