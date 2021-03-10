INC1 = -I${JAVA_HOME}/include/
INC2 = -I${JAVA_HOME}/include/darwin/

all:
	g++ -shared -o libHelloJNI.dylib -fPIC HelloJNI.cpp $(INC1) $(INC2)

clean:
	rm libHelloJNI.dylib
	rm -r build
