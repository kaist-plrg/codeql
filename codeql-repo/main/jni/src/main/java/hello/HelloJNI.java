package hello;

import java.lang.System;

public class HelloJNI {
  static{
    System.loadLibrary("HelloJNI");  
  }
  public native int f(int jparam1, String jparam2);

  public static void main(String[] args) throws Exception{
    HelloJNI jni = new HelloJNI();
    int jreturn = jni.f(42, "java_string");
  }
}
