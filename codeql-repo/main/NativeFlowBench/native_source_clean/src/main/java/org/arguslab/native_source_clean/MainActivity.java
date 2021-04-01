package org.arguslab.native_source_clean;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @author Fengguo Wei, Xingwei Lin
 * @testcase_name native_source_clean
 * @author_mail fgwei521@gmail.com, xwlin.roy@gmail.com
 * @description The native function clears sensitive data for argument fields.
 * @dataflow none sensitive -> sink
 * @number_of_leaks 0
 * @challenges The analysis must be able to track data flow in both java and native layers to avoid the false positive.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("source_clean"); // "libsource_clean.so"
    }

    public static native void sourceClean(ComplexData data);

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
        ComplexData complexData = new ComplexData();
        complexData.setData(imei);
        sourceClean(complexData);
        Log.d("source_clean", complexData.getData());
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
