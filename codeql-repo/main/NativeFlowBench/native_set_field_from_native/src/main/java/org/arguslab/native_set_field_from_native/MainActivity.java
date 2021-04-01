package org.arguslab.native_set_field_from_native;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

/**
 * @author Fengguo Wei, Xingwei Lin
 * @testcase_name native_set_field_from_native
 * @author_mail fgwei521@gmail.com, xwlin.roy@gmail.com
 * @description Native put sensitive into a field of Foo and set to field of Data and leak the field in Java.
 * @dataflow imei -> foo.data -> complexData.foo -> sink
 * @number_of_leaks 2
 * @challenges The analysis must be able to track data flow in both java and native layers to capture the data leakage.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("set_field_from_native"); // "libset_field_from_native.so"
    }

    public native Foo setField(ComplexData complexData);

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
        ComplexData complexData = new ComplexData();
        Foo fooRet = setField(complexData);
        Log.d("set_field_from_native", complexData.getFoo().getData());
        Log.d("set_field_from_native", fooRet.getData());
    }
}
