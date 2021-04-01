#include <jni.h>
#include <android/log.h>
#include <stddef.h>
#include <string.h>

#define LOG_TAG    "data"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1complexdata_1stringop_MainActivity_send(JNIEnv *env, jobject thisObj,
                                                                  jobject data);
}

const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

JNIEXPORT void JNICALL
Java_org_arguslab_native_1complexdata_1stringop_MainActivity_send(JNIEnv *env, jobject thisObj,
                                                                  jobject data) {
    char *p1 = "ot";
    char *p2 = "her";
    char *name = new char[10];
    strcpy(name, p1); // copy string one into the result.
    strcat(name, p2);
    jclass cd = env->GetObjectClass(data);
    jfieldID fd = env->GetFieldID(cd, name, "Ljava/lang/String;");
    jstring str = (jstring) env->GetObjectField(data, fd);
    LOGI("%s", getCharFromString(env, str)); // noleak
    return;
}