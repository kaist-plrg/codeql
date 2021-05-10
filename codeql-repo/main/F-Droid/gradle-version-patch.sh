while read line; do
  set $line

  mkdir -p $1/gradle/wrapper
  
  echo distributionUrl=https\\://services.gradle.org/distributions/gradle-$3-bin.zip \
  > $1/gradle/wrapper/gradle-wrapper.properties

  if [ ! -z $4 ]; then
    cp ../local.properties .
  fi
done < gradle-version-patch.txt
