package org.arguslab.native_noleak_array;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Fengguo Wei
 * @testcase_name native_noleak_array
 * @author_mail fgwei521@gmail.com
 * @description The value v set into an array and sent to native lib via jni.
 * native lib sinks other array index.
 * @dataflow
 * @number_of_leaks 0
 * @challenges The analysis must be able to track data flow in both java and native layers to avoid the false positive.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("noleak_array"); // "libnoleak.so"
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
