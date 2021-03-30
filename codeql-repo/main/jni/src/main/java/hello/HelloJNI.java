package hello;

import java.lang.System;

public class HelloJNI {
  static{
    System.loadLibrary("HelloJNI");  
  }
  public native int f(int java_param);

  public int java_callback(int java_callback_param) {
    return java_callback_param;
  }

  public int java_field;
  public static int java_static_field;

  public static void main(String[] args) throws Exception{
    HelloJNI jni = new HelloJNI();
   
    jni.java_field = 99;
    jni.java_static_field = 999;

    int val = jni.f(9);
    System.out.println(val);

    int java_field_write = jni.java_field;
    int java_static_field_write = jni.java_static_field;
    System.out.println(java_field_write);
    System.out.println(java_static_field_write);
  }
}
