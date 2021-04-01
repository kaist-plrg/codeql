//
// Created by Xingwei Lin on 14/01/18.
//

#include <jni.h>


#define LOG_TAG    "set_field_from_arg_field"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
JNIEXPORT jobject JNICALL
Java_org_arguslab_native_1set_1field_1from_1arg_1field_MainActivity_setField(JNIEnv *env,
                                                                             jobject thisObj,
                                                                             jobject complexData,
                                                                             jobject otherData);

}


JNIEXPORT jobject JNICALL
Java_org_arguslab_native_1set_1field_1from_1arg_1field_MainActivity_setField(JNIEnv *env,
                                                                             jobject thisObj,
                                                                             jobject complexData,
                                                                             jobject otherData) {
    jclass complexDataClass = env->GetObjectClass(complexData);
    jfieldID fooFieldID = env->GetFieldID(complexDataClass, "foo",
                                          "Lorg/arguslab/native_set_field_from_arg_field/Foo;");

    jobject foo = env->GetObjectField(otherData, fooFieldID);
    env->SetObjectField(complexData, fooFieldID, foo);
    jobject fooRet = env->GetObjectField(complexData, fooFieldID);
    return fooRet;
}

