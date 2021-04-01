//
// Created by Fengguo Wei on 3/4/18.
//

#include <jni.h>

extern "C" {
JNIEXPORT void JNICALL
Java_org_arguslab_native_1heap_1modify_MainActivity_heapModify(JNIEnv *env, jobject thisObj,
                                                               jobject mContext, jobject data);

}

jstring getImei(JNIEnv *env, jobject context) {
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

JNIEXPORT void JNICALL
Java_org_arguslab_native_1heap_1modify_MainActivity_heapModify(JNIEnv *env, jobject thisObj,
                                                               jobject mContext, jobject data) {
    jstring deviceid = getImei(env, mContext);
    jclass cd = env->GetObjectClass(data);
    jfieldID fd = env->GetFieldID(cd, "str", "Ljava/lang/String;");
    env->SetObjectField(data, fd, deviceid);
    return;
}