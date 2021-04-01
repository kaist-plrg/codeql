cmake_minimum_required(VERSION 3.4.1)

add_library(method_overloading SHARED
           src/main/jni/method_overloading.cpp)

target_link_libraries(method_overloading
                     android
                     log)