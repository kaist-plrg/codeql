#include "build/generated/sources/headers/java/main/hello_HelloJNI.h"
#include <stdio.h>

int c_callback(int c_callback_param) {
  return c_callback_param;
}

JNIEXPORT jint JNICALL Java_hello_HelloJNI_f (JNIEnv * env, jobject obj, jint c_param){
  // c callback function
  int c_return = c_callback(c_param);

  //java callback function
  jclass cls = env->GetObjectClass(obj);
  jmethodID mid = env->GetMethodID(cls, "java_callback", "(I)I");
  jint java_return = env->CallIntMethod(obj, mid, c_return);
  
  return java_return;
}
