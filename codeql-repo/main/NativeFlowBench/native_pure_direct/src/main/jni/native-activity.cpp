//
// Created by Xingwei Lin on 17/4/17.
//

#include <pthread.h>
#include <android/asset_manager.h>
#include <android/configuration.h>
#include <android/looper.h>
#include <android/native_activity.h>
#include <stdio.h>
#include <android/log.h>
#include <EGL/egl.h>

ANativeActivity *nativeActivity;

#define LOG_TAG    "native_pure_direct"
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

enum {
    looper_id_input,
    looper_id_sensor,
};


typedef volatile enum {
    main_thread_on_null,
    main_thread_on_wait,
    main_thread_on_resized,
    main_thread_on_pause,
    main_thread_on_resume,
    main_thread_on_first_resized,
    main_thread_on_destroy,
}
        MainThreadCallback;

//--------------------------------------------------------------------------------------------------

static struct {
    EGLDisplay display;
    EGLSurface surface;
    EGLContext context;
    EGLConfig config;
    EGLint format;

    AConfiguration *assetConfig;
    ANativeWindow *window;
    ALooper *looper;
    AInputQueue *inputQueue;

    // volatile make sure not optimized by the compiler
    // because two threads modify mainThreadCallback
    volatile MainThreadCallback mainThreadCallback;
}
        AData[1] =
        {
                {
                        .mainThreadCallback = main_thread_on_wait,
                }
        };

//--------------------------------------------------------------------------------------------------


const char *getCharFromString(JNIEnv *env, jstring string) {
    if (string == NULL)
        return NULL;

    return env->GetStringUTFChars(string, 0);
}

/**
 * get source
 */
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

/**
 * Process the next input event
 */
static inline int32_t OnInputEvent(AInputEvent *event) {
    switch (AInputEvent_getType(event)) {
        case AINPUT_EVENT_TYPE_MOTION: {
            int32_t action = AMotionEvent_getAction(event);

            switch (action & AMOTION_EVENT_ACTION_MASK) {
                // first pointer down
                case AMOTION_EVENT_ACTION_DOWN: {
                    LOGD("test AMOTION_EVENT_ACTION_DOWN");
                }
                    break;


                    // not first pointer down
                case AMOTION_EVENT_ACTION_POINTER_DOWN: {
                    int indexDown = (action & AMOTION_EVENT_ACTION_POINTER_INDEX_MASK)
                            >> AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT;
                    LOGD("test AMOTION_EVENT_POINTER_DOWN");

                }
                    break;


                    // first pinter up
                case AMOTION_EVENT_ACTION_UP: {
                    LOGD("test AMOTION_EVENT_ACTION_UP");
                }
                    break;


                    // not first pointer up
                case AMOTION_EVENT_ACTION_POINTER_UP: {
                    int indexUp = (action & AMOTION_EVENT_ACTION_POINTER_INDEX_MASK)
                            >> AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT;
                    LOGD("test AMOTION_EVENT_ACTION_POINTER_UP");

                }
                    break;

                case AMOTION_EVENT_ACTION_MOVE: {
                    LOGD("test AMOTION_EVENT_ACTION_MOVE");
                }
                    break;


                case AMOTION_EVENT_ACTION_CANCEL: {
                    LOGD("test AMOTION_EVENT_ACTION_CANCEL");
                }
                    break;

                default:
                    return 0;
            }

            return 1;
        }

        case AINPUT_EVENT_TYPE_KEY: {
            LOGD("test AMOTION_EVENT_TYPE_KEY");
        }

    }

    // default dispatching
    return 0;
}

static int LooperOnInputEvent(int fd, int events, void *data) {
    AInputEvent *event;

    while (AInputQueue_getEvent(AData->inputQueue, &event) >= 0) {
        if (AInputQueue_preDispatchEvent(AData->inputQueue, event) == 0) {
            AInputQueue_finishEvent(AData->inputQueue, event, OnInputEvent(event));
        }
    }

    return 1;
}


static void *ThreadRun(void *param) {
    AData->looper = ALooper_prepare(0);

//--------------------------------------------------------------------------------------------------

    while (true) {
        switch (AData->mainThreadCallback) {
            case main_thread_on_null:
                // handle event
                ALooper_pollAll(0, NULL, NULL, NULL);

                // application main loop
                // AApplication->Loop();

                // render buffer
                // eglSwapBuffers(AData->display, AData->surface);
                continue;

            case main_thread_on_destroy:
                // call in main thread
                // AEGLTool->DestroyEGL(&AData->display, &AData->context, &AData->surface);
                LOGD("test main_thread_on_destroy");
                return NULL;

            case main_thread_on_pause: // sometimes before resized
                // call in main thread
                // AApplication->Pause();
                AData->mainThreadCallback = main_thread_on_wait;
                LOGD("test main_thread_on_pause");
                continue;

            case main_thread_on_resume:
                // call in main thread
                // AApplication->Resume();
                AData->mainThreadCallback = main_thread_on_null;
                LOGD("test main_thread_on_resume");
                break;

            case main_thread_on_first_resized:
                // we need create EGL and use openGL in one thread
                // call in main thread
                // AEGLTool->CreateEGL(AData->window, &AData->display, &AData->context, &AData->surface, &AData->config);

                // EGL_NATIVE_VISUAL_ID is an attribute of the EGLConfig that is
                // guaranteed to be accepted by ANativeWindow_SetBuffersGeometry()
                // As soon as we picked a EGLConfig, we can safely reconfigure the
                // ANativeWindow buffers to match, using EGL_NATIVE_VISUAL_ID
                // eglGetConfigAttrib              (AData->display, AData->config, EGL_NATIVE_VISUAL_ID, &AData->format);
                // ANativeWindow_setBuffersGeometry(AData->window,  0, 0, AData->format);

                //AApplication->GLReady
                //(
                //    ANativeWindow_getWidth (AData->window),
                //   ANativeWindow_getHeight(AData->window)
                //);

                AData->mainThreadCallback = main_thread_on_null;
                LOGD("test main_thread_on_first_resized");
                break;

            case main_thread_on_resized:
                // call in main thread
                // AEGLTool->ResetSurface          (AData->window, AData->display, AData->context, AData->config, &AData->surface);
                //ANativeWindow_setBuffersGeometry(AData->window, 0, 0, AData->format);
                //AApplication->Resized           (ANativeWindow_getWidth(AData->window), ANativeWindow_getHeight(AData->window));
                AData->mainThreadCallback = main_thread_on_null;
                LOGD("test main_thread_on_resized");
                break;
        }
    }

    return NULL;
}

//--------------------------------------------------------------------------------------------------

static inline void SaveData(ANativeActivity *activity) {


}


static void OnStart(ANativeActivity *activity) {
    LOGD("NativeActivity OnStart");
    JNIEnv *env = activity->env;
    activity->vm->AttachCurrentThread(&env, 0);
    jobject context = activity->clazz;
    jstring imei = getImei(env, context); // source
    LOGD("Device ID: %s", getCharFromString(env, imei));  // leak

}

static void OnResume(ANativeActivity *activity) {
    LOGD("NativeActivity OnResume");
    AData->mainThreadCallback = main_thread_on_resume;
}

static void *OnSaveInstanceState(ANativeActivity *activity, size_t *outSize) {
    LOGD("NativeActivity OnSaveInstanceState");
    SaveData(activity);
    *outSize = 0;
    return NULL;
}

static void OnPause(ANativeActivity *activity) {
    LOGD("NativeActivity OnPause");
    AData->mainThreadCallback = main_thread_on_pause;
}

static void OnStop(ANativeActivity *activity) {
    LOGD("NativeActivity OnStop");
}

static void OnDestroy(ANativeActivity *activity) {
    LOGD("NativeActivity OnDestroy");
    AData->mainThreadCallback = main_thread_on_destroy;
}

static void OnWindowFocusChanged(ANativeActivity *activity, int hasFocus) {
    LOGD("NativeActivity OnWindowFocusChanged");
}

static void OnNativeWindowCreated(ANativeActivity *activity, ANativeWindow *window) {
    LOGD("NativeActivity OnNativeWindowCreated");
    AData->window = window;
}

static void OnNativeWindowResized(ANativeActivity *activity, ANativeWindow *window) {
    LOGD("NativeActivity OnNativeWindowResized");
    AData->window = window;

    static bool isFirst = true;
    if (isFirst) {
        isFirst = false;
        AData->mainThreadCallback = main_thread_on_first_resized;
    } else {
        AData->mainThreadCallback = main_thread_on_resized;
    }
}

static void OnNativeWindowRedrawNeeded(ANativeActivity *activity, ANativeWindow *window) {
    LOGD("NativeActivity OnNativeWindowRedrawNeeded");
    AData->mainThreadCallback = main_thread_on_null;
}

static void OnNativeWindowDestroyed(ANativeActivity *activity, ANativeWindow *window) {
    LOGD("NativeActivity OnNativeWindowDestroyed");
    AData->mainThreadCallback = main_thread_on_wait;
}

static void OnInputQueueCreated(ANativeActivity *activity, AInputQueue *inputQueue) {
    LOGD("NativeActivity OnInputQueueCreated");
    AData->inputQueue = inputQueue;
    AInputQueue_attachLooper(inputQueue, AData->looper, looper_id_input, LooperOnInputEvent, NULL);
}

static void OnInputQueueDestroyed(ANativeActivity *activity, AInputQueue *inputQueue) {
    LOGD("NativeActivity OnInputQueueDestroyed");
    AInputQueue_detachLooper(inputQueue);
}

static void OnContentRectChanged(ANativeActivity *activity, const ARect *rect) {
    LOGD("NativeActivity OnContentRectChanged");
}

static void OnConfigurationChanged(ANativeActivity *activity) {
    LOGD("NativeActivity OnConfigurationChanged");
    AConfiguration_fromAssetManager(AData->assetConfig, activity->assetManager);
}

static void OnLowMemory(ANativeActivity *activity) {
    LOGD("NativeActivity OnLowMemory");
}

//--------------------------------------------------------------------------------------------------
/**
 * @testcase_name native_pure_direct
 * @author Fengguo Wei
 * @author_mail fgwei521@gmail.com
 *
 * @description The imei of a source is retrieved and leaked by the native Activity.
 * @dataflow source -> imei -> -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to model NativeActivity and understand the native source and sink properly.
 */
void ANativeActivity_onCreate(ANativeActivity *activity, void *savedState, size_t savedStateSize) {
    LOGD("ANativeActivityOnCreate Start");
    nativeActivity = activity;

    activity->callbacks->onStart = OnStart;
    activity->callbacks->onResume = OnResume;
    activity->callbacks->onSaveInstanceState = OnSaveInstanceState;
    activity->callbacks->onPause = OnPause;
    activity->callbacks->onStop = OnStop;
    activity->callbacks->onDestroy = OnDestroy;
    activity->callbacks->onWindowFocusChanged = OnWindowFocusChanged;
    activity->callbacks->onNativeWindowCreated = OnNativeWindowCreated;
    activity->callbacks->onNativeWindowResized = OnNativeWindowResized;
    activity->callbacks->onNativeWindowRedrawNeeded = OnNativeWindowRedrawNeeded;
    activity->callbacks->onNativeWindowDestroyed = OnNativeWindowDestroyed;
    activity->callbacks->onInputQueueCreated = OnInputQueueCreated;
    activity->callbacks->onInputQueueDestroyed = OnInputQueueDestroyed;
    activity->callbacks->onContentRectChanged = OnContentRectChanged;
    activity->callbacks->onConfigurationChanged = OnConfigurationChanged;
    activity->callbacks->onLowMemory = OnLowMemory;

    //AApplication->Init();

//--------------------------------------------------------------------------------------------------

    AData->assetConfig = AConfiguration_new();
    AConfiguration_fromAssetManager(AData->assetConfig, activity->assetManager);

    pthread_t thread[1];
    pthread_attr_t attr[1];
    pthread_attr_init(attr);
    pthread_attr_setdetachstate(attr, PTHREAD_CREATE_DETACHED);
    pthread_create(thread, attr, ThreadRun, NULL);
    pthread_attr_destroy(attr);
}

