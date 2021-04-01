package org.arguslab.icc_javatonative;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;

/**
 * @author Fengguo Wei
 * @testcase_name ICC_JavaToNative
 * @author_mail fgwei521@gmail.com
 * @description The value v of a source is sent to native Activity via Intent.
 * native Activity leaks the sensitive data.
 * @dataflow source -> imei -> MainActivity's intent -> NativeActivity's intent -> data -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends Activity {

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
        Intent intent = new Intent(this, android.app.NativeActivity.class);
        intent.putExtra("data", imei);
        startActivity(intent);
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
