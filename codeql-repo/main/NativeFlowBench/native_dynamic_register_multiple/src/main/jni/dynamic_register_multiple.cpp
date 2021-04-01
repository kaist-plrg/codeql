//
// Created by Xingwei Lin on 6/12/17.
//

#include <android/log.h>
#include <jni.h>
#include <stddef.h>
#include <assert.h>

#define LOG_TAG    "dynamic_register_multiple"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

#define JNIREG_CLASS "org/arguslab/native_dynamic_register_multiple/MainActivity"

extern "C" {
JNIEXPORT void JNICALL native_send(JNIEnv *env, jobject thisObj, jstring data);
JNIEXPORT void JNICALL native_sendFoo(JNIEnv *env, jobject thisObj, jint index, jstring data);
JNIEXPORT void JNICALL native_sendBar(JNIEnv *env, jobject thisObj, jdouble dw, jstring data);
}

const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

JNIEXPORT void JNICALL native_send(JNIEnv *env, jobject thisObj, jstring data) {
    LOGI("IMEI: %s", getCharFromString(env, data)); // leak
    return;
}

JNIEXPORT void JNICALL native_sendFoo(JNIEnv *env, jobject thisObj, jint index, jstring data) {
    LOGI("IMEI: %s", getCharFromString(env, data)); // leak
    return;
}

JNIEXPORT void JNICALL native_sendBar(JNIEnv *env, jobject thisObj, jdouble dw, jstring data) {
    LOGI("IMEI: %s", getCharFromString(env, data)); // leak
    return;
}

/**
* Table of methods associated with a single class.
*/
static JNINativeMethod gMethods[] = {
        {"send",    "(Ljava/lang/String;)V",  (void *) native_send},
        {"sendFoo", "(ILjava/lang/String;)V", (void *) native_sendFoo},
        {"sendBar", "(DLjava/lang/String;)V", (void *) native_sendBar},
};

/*
* Register several native methods for one class.
*/
static int registerNativeMethods(JNIEnv *env, const char *className,
                                 JNINativeMethod *gMethods, int numMethods) {
    jclass clazz;
    clazz = env->FindClass(className);
    if (clazz == NULL) {
        return JNI_FALSE;
    }
    if (env->RegisterNatives(clazz, gMethods, numMethods) < 0) {
        return JNI_FALSE;
    }

    return JNI_TRUE;
}


/*
* Register native methods for all classes we know about.
*/
static int registerNatives(JNIEnv *env) {
    if (!registerNativeMethods(env, JNIREG_CLASS, gMethods,
                               sizeof(gMethods) / sizeof(gMethods[0]))) {
        return JNI_FALSE;
    }

    return JNI_TRUE;
}

/*
* Set some test stuff up.
*
* Returns the JNI version on success, -1 on failure.
*/
JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *env = NULL;
    jint result = -1;

    if (vm->GetEnv((void **) &env, JNI_VERSION_1_4) != JNI_OK) {
        return -1;
    }
    assert(env != NULL);

    if (!registerNatives(env)) {    // Register
        return -1;
    }
    /* success -- return valid version number */
    result = JNI_VERSION_1_4;

    return result;
}