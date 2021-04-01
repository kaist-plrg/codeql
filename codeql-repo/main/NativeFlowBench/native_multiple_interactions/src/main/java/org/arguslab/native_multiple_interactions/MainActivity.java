package org.arguslab.native_multiple_interactions;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Fengguo Wei, Xingwei Lin
 * @testcase_name native_multiple_interactions
 * @author_mail fgwei521@gmail.com, xwlin.roy@gmail.com
 * @description Pass a sensitive data to first native function which invoke back to java then invoke second native function leak it.
 * @dataflow imei -> d.str -> Java_org_arguslab_native_1multiple_1interactions_MainActivity_propagateImei
 * -> toNativeAgain -> Java_org_arguslab_native_1multiple_1interactions_MainActivity_leakImei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to correctly handle interleaving.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("multiple_interactions"); // "multiple_interactions.dll" in Windows, "libmultiple_interactions.so" in Unixes
    }

    public native void propagateImei(Data d);

    public native void leakImei(String imei);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
        }
    }

    private void toNative(Data d, String imei) {
        d.str = imei;
        propagateImei(d);
    }

    public void toNativeAgain(String data) {
        leakImei(data);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case 1: {
                TelephonyManager tel =
                        (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
                if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                    return;
                }
                String imei = tel.getDeviceId(); // source
                Data d = new Data();
                toNative(d, imei);
                return;
            }
        }
    }
}
