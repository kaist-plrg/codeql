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
  
  public static int java_s_callback(int java_s_callback_param) {
    return java_s_callback_param;
  }

  public static void main(String[] args) throws Exception{
    HelloJNI jni = new HelloJNI();
   
    int val = jni.f(42);
    System.out.println(val);
  }
}
