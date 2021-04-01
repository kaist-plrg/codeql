#include <jni.h>
#include <android/log.h>
#include <stddef.h>

#define LOG_TAG    "data"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1complexdata_MainActivity_send(JNIEnv *env, jobject thisObj, jobject data);
JNIEXPORT void JNICALL
Java_org_arguslab_native_1complexdata_MainActivity_send2(JNIEnv *env, jobject thisObj,
                                                         jobject data);
}

const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1complexdata_MainActivity_send(JNIEnv *env, jobject thisObj,
                                                        jobject data) {
    jclass cd = env->GetObjectClass(data);
    jmethodID gd = env->GetMethodID(cd, "getData", "()Ljava/lang/String;");
    jstring str = (jstring) env->CallObjectMethod(data, gd);
    LOGI("%s", getCharFromString(env, str)); // leak
    return;
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1complexdata_MainActivity_send2(JNIEnv *env, jobject thisObj,
                                                         jobject data) {
    jclass cd = env->GetObjectClass(data);
    jmethodID gd = env->GetMethodID(cd, "getOther", "()Ljava/lang/String;");
    jstring str = (jstring) env->CallObjectMethod(data, gd);
    LOGI("%s", getCharFromString(env, str));
    return;
}