cmake_minimum_required(VERSION 3.4.1)

add_library(source_clean SHARED
           src/main/jni/source_clean.cpp)

target_link_libraries(source_clean
                     android
                     log)