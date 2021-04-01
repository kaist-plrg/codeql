package org.arguslab.native_multiple_libraries;

import android.app.Activity;
import android.os.Bundle;

import android.Manifest;
import android.content.pm.PackageManager;
import android.telephony.TelephonyManager;

/**
 * @author Xingwei Lin
 * @testcase_name native_multiple_libraries
 * @author_mail xwlin.roy@gmail.com
 * @description The value v of a source is sent to native lib via jni.
 * native lib is not leaking the data.
 * @dataflow imei -> masterSend -> libmaster.so .masterSend -> leak
 * @number_of_leaks 1
 * @challenges The analysis must success find native function when multiple library is loaded.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("master"); // "libmaster.so"
        System.loadLibrary("foo"); // "libfoo.so"
    }

    public static native void masterSend(String data);

    public static native void fooSend(String data);

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
        masterSend(imei);
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
