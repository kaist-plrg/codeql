//
// Created by Fengguo Wei on 6/12/17.
//

#include <android/log.h>
#include <jni.h>
#include <stddef.h>

#define LOG_TAG    "method_overloading"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1method_1overloading_MainActivity_send__I(JNIEnv *env, jobject thisObj,
                                                                   jint data);
JNIEXPORT void JNICALL
Java_org_arguslab_native_1method_1overloading_MainActivity_send___3I_3Ljava_lang_String_2Ljava_lang_String_2D(
        JNIEnv *env, jobject thisObj, jintArray array, jobjectArray array2, jstring data,
        jdouble d);
}

const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1method_1overloading_MainActivity_send__I(JNIEnv *env, jobject thisObj,
                                                                   jint data) {
    LOGI("%s", data); // leak
    return;
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1method_1overloading_MainActivity_send___3I_3Ljava_lang_String_2Ljava_lang_String_2D(
        JNIEnv *env, jobject thisObj, jintArray array, jobjectArray array2, jstring data,
        jdouble d) {

    LOGI("%s", getCharFromString(env, data)); // leak
    return;
}
