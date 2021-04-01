//
// Created by Fengguo Wei, Xingwei Lin on 3/4/18.
//

#include <jni.h>
#include <android/log.h>
#include <stddef.h>

#define LOG_TAG    "multiple_interactions"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1multiple_1interactions_MainActivity_propagateImei(JNIEnv *env,
                                                                            jobject thisObj,
                                                                            jobject data);

JNIEXPORT void JNICALL
Java_org_arguslab_native_1multiple_1interactions_MainActivity_leakImei(JNIEnv *env, jobject thisObj,
                                                                       jstring imei);

}

const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1multiple_1interactions_MainActivity_propagateImei(JNIEnv *env,
                                                                            jobject thisObj,
                                                                            jobject data) {
    jclass cd = env->GetObjectClass(data);
    jfieldID fd = env->GetFieldID(cd, "str", "Ljava/lang/String;");
    jobject imei = env->GetObjectField(data, fd);
    cd = env->FindClass("org/arguslab/native_multiple_interactions/MainActivity");
    jmethodID gd = env->GetMethodID(cd, "toNativeAgain", "(Ljava/lang/String;)V");
    env->CallVoidMethod(thisObj, gd, imei);
    return;
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1multiple_1interactions_MainActivity_leakImei(JNIEnv *env, jobject thisObj,
                                                                       jstring imei) {
    LOGI("%s", getCharFromString(env, imei)); // leak
    return;
}