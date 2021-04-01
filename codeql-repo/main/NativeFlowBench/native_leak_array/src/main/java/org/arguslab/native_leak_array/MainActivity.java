package org.arguslab.native_leak_array;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Xingwei Lin
 * @testcase_name Native_Leak_Array
 * @author_mail xwlin.roy@gmail.com
 * @description The value v set into an array and sent to native lib via jni.
 * native lib leaks the sensitive data.
 * @dataflow source -> imei -> arr[1] -> send -JNI-> Java_org_arguslab_native_1leak_1array_MainActivity_send -> imei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("leak_array"); // "libleak_array.so"
    }

    public static native void send(String[] data);

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
        String[] arr = new String[10];
        arr[1] = imei;
        send(arr);
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