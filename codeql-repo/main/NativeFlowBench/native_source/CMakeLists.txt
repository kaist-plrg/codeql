cmake_minimum_required(VERSION 3.4.1)

add_library(source SHARED
           src/main/jni/source.cpp)

target_link_libraries(source
                     android
                     log)