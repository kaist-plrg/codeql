#include "build/generated/sources/headers/java/main/hello_HelloJNI.h"
#include <stdio.h>

JNIEXPORT void JNICALL Java_hello_HelloJNI_printHello (JNIEnv * env, jobject obj){
   printf("Hello World!\n");
   return;
}

JNIEXPORT jint JNICALL Java_hello_HelloJNI_add (JNIEnv * env, jobject obj, jint a, jint b){
  return a + b;
}
