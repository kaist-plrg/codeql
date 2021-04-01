//
// Created by Fengguo Wei on 3/5/17.
//

#include <android/log.h>
#include <jni.h>


#define LOG_TAG    "noleak"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1noleak_MainActivity_send(JNIEnv *env, jobject thisObj, jstring data);
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1noleak_MainActivity_send(JNIEnv *env, jobject thisObj, jstring data) {
    LOGI("some data");
    return;
}