#include <jni.h>

#include <EGL/egl.h>
#include <GLES/gl.h>

#include <android/sensor.h>
#include <android/log.h>
#include <android_native_app_glue.h>

#define LOG_TAG    "native-activity"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

void handleIntent(struct android_app *state) {
    JNIEnv *env;
    state->activity->vm->AttachCurrentThread(&env, 0);

    jobject me = state->activity->clazz;

    jclass acl = env->GetObjectClass(me); //class pointer of NativeActivity
    jmethodID giid = env->GetMethodID(acl, "getIntent", "()Landroid/content/Intent;");
    jobject intent = env->CallObjectMethod(me, giid); //Got our intent

    jclass icl = env->GetObjectClass(intent); //class pointer of Intent
    jmethodID gseid = env->GetMethodID(icl, "getStringExtra",
                                       "(Ljava/lang/String;)Ljava/lang/String;");

    jstring imei = (jstring) env->CallObjectMethod(intent, gseid, env->NewStringUTF("data"));
    LOGI("%s", getCharFromString(env, imei)); // leak
}

/**
 * Main entry point, handles events
 */
void android_main(struct android_app *state) {
    app_dummy();

    handleIntent(state);
    // Read all pending events.
    while (1) {
        int ident;
        int events;
        struct android_poll_source *source;

        while ((ident = ALooper_pollAll(0, NULL, &events, (void **) &source)) >= 0) {

            // Process this event.
            if (source != NULL) {
                source->process(state, source);
            }
            // Check if we are exiting.
            if (state->destroyRequested != 0) {
                return;
            }
        }
    }
}