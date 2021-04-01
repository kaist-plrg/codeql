package org.arguslab.icc_nativetojava;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;

/**
 * @author Fengguo Wei
 * @testcase_name ICC_NativeToJava
 * @author_mail fgwei521@gmail.com
 * @description The value v of a source is sent to native lib via jni.
 * native lib leaks the sensitive data.
 * @dataflow source -> imei -> sendIntent -JNI-> Java_org_arguslab_icc_1nativetojava_MainActivity_sendIntent -> MainActivity's Intent -> FooActivity's Intent -> data -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to handle Intent created in native layer to capture the data leakage.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("intent"); // "intent.dll" in Windows, "libintent.so" in Unixes
    }

    public native void sendIntent(String data);

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
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        String imei = tel.getDeviceId(); // source
        sendIntent(imei);
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
