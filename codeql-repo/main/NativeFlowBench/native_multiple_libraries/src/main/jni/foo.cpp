//
// Created by Xingwei Lin on 26/4/18.
//

#include <android/log.h>
#include <jni.h>


#define LOG_TAG    "foo"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1multiple_1libraries_MainActivity_fooSend(JNIEnv *env, jobject thisObj,
                                                                   jstring data);
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1multiple_1libraries_MainActivity_fooSend(JNIEnv *env, jobject thisObj,
                                                                   jstring data) {
    LOGI("some data");
    return;
}