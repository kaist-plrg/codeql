package org.arguslab.native_complexdata;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Fengguo Wei
 * @testcase_name native_complexdata
 * @author_mail fgwei521@gmail.com
 * @description Put sensitive into a field of Data and leak the field in native.
 * @dataflow imei -> d.data -JNI-> Java_org_arguslab_native_1complexdata_MainActivity_send -> imei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends Activity {
    static {
        System.loadLibrary("data"); // "libdata.so"
    }

    public static native void send(ComplexData data);

    public static native void send2(ComplexData data);

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
        ComplexData data = new ComplexData();
        data.setData(imei);
        data.setOther("nosource");
        send(data);
        send2(data);
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
