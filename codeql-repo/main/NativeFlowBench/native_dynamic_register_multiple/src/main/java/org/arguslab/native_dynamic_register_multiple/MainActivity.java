package org.arguslab.native_dynamic_register_multiple;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Xingwei Lin
 * @testcase_name native_dynamic_register_multiple
 * @author_mail xwlin.roy@gmail.com
 * @description The value v of a source is sent to native lib via jni.
 * Native lib leaks the sensitive data.
 * The native methods are dynamic registered by JNI_OnLoad.
 * @dataflow source -> imei -> send -JNI-> native_send -> data -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to match the corresponding native method registered by JNI_OnLoad.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("dynamic_register_multiple"); // "libdynamic_register_multiple.so"
    }

    public static native void send(String data);

    public static native void sendFoo(int index, String data);

    public static native void sendBar(double dw, String data);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
        }
    }

    private void leakImei() {
        TelephonyManager tel = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        String imei = tel.getDeviceId(); // source
        send(imei);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case 1: {
                leakImei();
                return;
            }
        }
    }
}
