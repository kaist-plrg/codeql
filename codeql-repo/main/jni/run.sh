# build java project
gradle build

# Compile C file into library file
make

# Execute
cd build/classes/java/main/
java hello.HelloJNI
