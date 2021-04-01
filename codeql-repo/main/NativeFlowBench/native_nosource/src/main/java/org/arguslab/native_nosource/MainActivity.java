package org.arguslab.native_nosource;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

/**
 * @author Fengguo Wei, Xingwei Lin
 * @testcase_name native_nosource
 * @author_mail fgwei521@gmail.com, xwlin.roy@gmail.com
 * @description The native function does not return sensitive data.
 * @dataflow
 * @number_of_leaks 0
 * @challenges The analysis must be able to track data flow in both java and native layers to avoid the false positive.
 */
public class MainActivity extends Activity {

    static {
        System.loadLibrary("nosource"); // "libnosource.so"
    }

    public static native String getData();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        String data = getData();
        Log.i("Data", data);
    }

}
