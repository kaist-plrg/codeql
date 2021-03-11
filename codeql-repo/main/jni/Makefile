INC1 = -I${JAVA_HOME}/include/
INC2 = -I${JAVA_HOME}/include/darwin/

all:
	g++ -shared -o libHelloJNI.dylib -fPIC HelloJNI.cpp $(INC1) $(INC2)
	cp libHelloJNI.dylib build/classes/java/main/

clean:
	rm libHelloJNI.dylib
	rm -r build
