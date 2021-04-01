package org.arguslab.icc_nativetojava;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

public class FooActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_foo);
        String data = getIntent().getStringExtra("data") + "";
        Log.i("imei", data); // leak
    }
}
