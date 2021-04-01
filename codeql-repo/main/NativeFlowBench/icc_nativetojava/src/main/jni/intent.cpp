#include <jni.h>

#define LOG_TAG    "intent"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_icc_1nativetojava_MainActivity_sendIntent(JNIEnv *env, jobject thisObj,
                                                            jstring data);
}

JNIEXPORT void JNICALL
Java_org_arguslab_icc_1nativetojava_MainActivity_sendIntent(JNIEnv *env, jobject thisObj,
                                                            jstring data) {
    jclass intent = env->FindClass("android/content/Intent");
    jmethodID constructor = env->GetMethodID(intent, "<init>", "()V");
    jobject i = env->NewObject(intent, constructor);
    jmethodID scnid = env->GetMethodID(intent, "setClassName",
                                       "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;");
    i = env->CallObjectMethod(i, scnid, env->NewStringUTF("org.arguslab.icc_nativetojava"),
                              env->NewStringUTF("org.arguslab.icc_nativetojava.FooActivity"));
    jmethodID pseid = env->GetMethodID(intent, "putExtra",
                                       "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;");
    i = env->CallObjectMethod(i, pseid, env->NewStringUTF("data"), data);
    jclass context = env->FindClass("android/content/Context");
    jmethodID said = env->GetMethodID(context, "startActivity", "(Landroid/content/Intent;)V");
    env->CallVoidMethod(thisObj, said, i);
    return;
}