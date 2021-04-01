package org.arguslab.native_method_overloading;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Fengguo Wei
 * @testcase_name native_method_overloading
 * @author_mail fgwei521@gmail.com
 * @description The value v of a source is sent to an overloaded native function f2.
 * f2 is not leaking the data.
 * @dataflow
 * @number_of_leaks 0
 * @challenges The analysis must be able to correctly handle method overloading.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("method_overloading");
    }

    native void send(int data);

    native void send(int[] array, String[] array2, String data, double d);

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
        send(new int[1], new String[1], imei, 0D);
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
