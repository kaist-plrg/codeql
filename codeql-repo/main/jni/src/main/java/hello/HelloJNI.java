package hello;

import java.lang.System;

public class HelloJNI {
  static{
    System.loadLibrary("HelloJNI");  
  }
  public native void printHello();
  public native int add(int a, int b);

  public static void main(String[] args) throws Exception{
    HelloJNI jni = new HelloJNI();
    jni.printHello();

    System.out.println(jni.add(3,4));
  }
}
