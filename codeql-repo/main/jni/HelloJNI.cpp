#include "build/generated/sources/headers/java/main/hello_HelloJNI.h"
#include <stdio.h>

int c_callback(int c_callback_param) {
  return c_callback_param;
}

JNIEXPORT jint JNICALL Java_hello_HelloJNI_f (JNIEnv * env, jobject obj, jint c_param){
  // c callback function
  int c_return = c_callback(c_param);

  // java callback function
  jclass cls = env->GetObjectClass(obj);
  jmethodID mid = env->GetMethodID(cls, "java_callback", "(I)I");
  jint java_return = env->CallIntMethod(obj, mid, c_return);

  // java field access
  jfieldID fid = env->GetFieldID(cls, "java_field", "I");
  jint java_field_read = env->GetIntField(obj, fid);
  printf("field: %d", java_field_read);
  env->SetIntField(obj, fid, 100);
  
  // java static field access
  jfieldID static_fid = env->GetStaticFieldID(cls, "java_static_field", "I");
  jint java_static_field_read = env->GetStaticIntField(cls, static_fid);
  printf("static field: %d", java_static_field_read);
  env->SetStaticIntField(cls, static_fid, 1000);

  return java_return;
}
