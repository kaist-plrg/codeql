#include <jni.h>
#include <android/log.h>
#include <stddef.h>

#define LOG_TAG    "source_clean"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1source_1clean_MainActivity_sourceClean(JNIEnv *env, jobject thisObj,
                                                                 jobject data);
}


JNIEXPORT void JNICALL
Java_org_arguslab_native_1source_1clean_MainActivity_sourceClean(JNIEnv *env, jobject thisObj,
                                                                 jobject data) {
    jclass complexDataClass = env->GetObjectClass(data);
    jfieldID dataFieldID = env->GetFieldID(complexDataClass, "data", "Ljava/lang/String;");
    jstring dataClean = env->NewStringUTF("Clean the data in the native");
    env->SetObjectField(data, dataFieldID, dataClean);
    return;
}