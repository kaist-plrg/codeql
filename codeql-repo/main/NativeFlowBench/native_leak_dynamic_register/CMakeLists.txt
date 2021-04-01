cmake_minimum_required(VERSION 3.4.1)

add_library(leak_dynamic_register SHARED
           src/main/jni/leak_dynamic_register.cpp)

target_link_libraries(leak_dynamic_register
                     android
                     log)