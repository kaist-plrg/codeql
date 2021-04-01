package org.arguslab.native_set_field_from_arg_field;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @author Fengguo Wei, Xingwei Lin
 * @testcase_name native_set_field_from_arg_field
 * @author_mail fgwei521@gmail.com, xwlin.roy@gmail.com
 * @description Put sensitive into a field of Foo and put into field of otherData and native set to field of complexData and leak the field in Java.
 * @dataflow imei -> foo.data -> complexData.foo -> sink
 * @number_of_leaks 2
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("set_field_from_arg_field"); // "libset_field_from_arg_field.so"
    }

    public static native Foo setField(ComplexData complexData, ComplexData otherData);

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

    @SuppressLint("LongLogTag")
    private void leakImei() {
        TelephonyManager tel = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
        if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        String imei = tel.getDeviceId(); // source
        ComplexData complexData = new ComplexData();
        ComplexData otherData = new ComplexData();

        Foo foo = new Foo();
        foo.setIndex(2018);
        foo.setData(imei);
        otherData.setFoo(foo);
        Foo fooRet = setField(complexData, otherData);
        Log.d("set_field_from_arg_field", complexData.getFoo().getData());
        Log.d("set_field_from_arg_field", fooRet.getData());
    }
}
