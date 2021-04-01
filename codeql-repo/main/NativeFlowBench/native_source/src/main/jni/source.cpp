//
// Created by Fengguo Wei on 3/5/18.
//

#include <jni.h>

extern "C" {
JNIEXPORT jstring JNICALL
Java_org_arguslab_native_1source_MainActivity_getImei(JNIEnv *env, jobject thisObj,
                                                      jobject context);

}

JNIEXPORT jstring JNICALL
Java_org_arguslab_native_1source_MainActivity_getImei(JNIEnv *env, jobject thisObj,
                                                      jobject context) {
    jclass cls = env->FindClass("android/content/Context");
    jmethodID mid = env->GetMethodID(cls, "getSystemService",
                                     "(Ljava/lang/String;)Ljava/lang/Object;");
    jfieldID fid = env->GetStaticFieldID(cls, "TELEPHONY_SERVICE",
                                         "Ljava/lang/String;");
    jstring str = (jstring) env->GetStaticObjectField(cls, fid);
    jobject telephony = env->CallObjectMethod(context, mid, str);
    cls = env->FindClass("android/telephony/TelephonyManager");
    mid = env->GetMethodID(cls, "getDeviceId", "()Ljava/lang/String;");
    jstring imei = (jstring) env->CallObjectMethod(telephony, mid); // source
    return imei;
}