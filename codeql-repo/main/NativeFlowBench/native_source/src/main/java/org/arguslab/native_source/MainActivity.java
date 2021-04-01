package org.arguslab.native_source;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

/**
 * @author Fengguo Wei
 * @testcase_name native_source
 * @author_mail fgwei521@gmail.com
 * @description The value v of a source is sent to native lib via jni.
 * native lib leaks the sensitive data.
 * @dataflow native source -> imei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends AppCompatActivity {
    static {
        System.loadLibrary("source"); // "libsource.so"
    }

    public static native String getImei(Context myContext);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
        }
    }

    private void leakImei() {
        String imei = getImei(getApplicationContext()); // source
        Log.i("imei", imei); // sink
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
