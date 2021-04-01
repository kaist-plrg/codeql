package org.arguslab.native_set_field_from_arg;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;


/**
 * @author Fengguo Wei, Xingwei Lin
 * @testcase_name native_set_field_from_arg
 * @author_mail fgwei521@gmail.com, xwlin.roy@gmail.com
 * @description Put sensitive into a field of Foo and native set to field of Data and leak the field in Java.
 * @dataflow imei -> foo.data -> complexData.foo -> sink
 * @number_of_leaks 2
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("set_field_from_arg"); // "libset_field_from_arg.so"
    }

    public native Foo setField(ComplexData complexData, Foo foo);


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
        }
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

    private void leakImei() {
        TelephonyManager tel = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        String imei = tel.getDeviceId(); // source
        ComplexData complexData = new ComplexData();

        Foo foo = new Foo();
        foo.setIndex(2018);
        foo.setData(imei);
        Foo fooRet = setField(complexData, foo);
        Log.d("setField", complexData.getFoo().getData()); // leak
        Log.d("setField", fooRet.getData()); // leak
    }
}
