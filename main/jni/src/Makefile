INC1 = -I${JAVA_HOME}/include/
INC2 = -I${JAVA_HOME}/include/linux/
INC3 = -I${JAVA_HOME}/include/darwin/

all:
	g++ -shared -o libHelloJNI.so -fPIC HelloJNI.cpp $(INC1) $(INC2) $(INC3)
	cp libHelloJNI.so build/classes/java/main/
	cp libHelloJNI.so build/classes/java/main/libHelloJNI.dylib

clean:
	rm libHelloJNI.so
	rm libHelloJNI.dylib
	rm -r build
