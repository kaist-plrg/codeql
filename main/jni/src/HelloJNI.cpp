#include "build/generated/sources/headers/java/main/hello_HelloJNI.h"
#include <stdio.h>

int c_callback(int c_callback_param) {
  return c_callback_param;
}

JNIEXPORT jint JNICALL Java_hello_HelloJNI_f (JNIEnv * env, jobject obj, jint c_param){
  // c callback function
  int c_return = c_callback(c_param);

  jclass cls = env->GetObjectClass(obj);

  // java callback function
  jmethodID mid = env->GetMethodID(cls, "java_callback", "(I)I");
  jint java_return = env->CallIntMethod(obj, mid, c_return);

  // java static function
  jmethodID s_mid = env->GetStaticMethodID(cls, "java_s_callback", "(I)I");
  jint java_s_return = env->CallStaticIntMethod(cls, s_mid, java_return);

  return java_s_return;
}
