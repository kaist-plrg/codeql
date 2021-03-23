#include "build/generated/sources/headers/java/main/hello_HelloJNI.h"
#include <stdio.h>

int myf(int arg1, const char* arg2) {
  return arg1;
}

JNIEXPORT jint JNICALL Java_hello_HelloJNI_f (JNIEnv * env, jobject obj, jint cparam1, jstring cparam2){
  const char *str = env->GetStringUTFChars(cparam2, 0);
  int creturn = myf(cparam1, str);
  env->ReleaseStringUTFChars(cparam2, str);
 
  return creturn;
}
