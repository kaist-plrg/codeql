cmake_minimum_required(VERSION 3.4.1)

add_library(dynamic_register_multiple SHARED
           src/main/jni/dynamic_register_multiple.cpp)

target_link_libraries(dynamic_register_multiple
                     android
                     log)