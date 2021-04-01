//
// Created by Xingwei Lin on 7/5/18.
//

#include <jni.h>

extern "C" {
JNIEXPORT jstring JNICALL
Java_org_arguslab_native_1nosource_MainActivity_getData(JNIEnv *env, jobject thisObj);

}

JNIEXPORT jstring JNICALL
Java_org_arguslab_native_1nosource_MainActivity_getData(JNIEnv *env, jobject thisObj) {
    jstring nosource = env->NewStringUTF("NO SOURCE");
    return nosource;
}