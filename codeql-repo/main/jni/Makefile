INC1 = -I${JAVA_HOME}/include/
INC2 = -I${JAVA_HOME}/include/linux/

all:
	g++ -shared -o libHelloJNI.so -fPIC HelloJNI.cpp $(INC1) $(INC2)
	cp libHelloJNI.so build/classes/java/main/

clean:
	rm libHelloJNI.so
	rm -r build
