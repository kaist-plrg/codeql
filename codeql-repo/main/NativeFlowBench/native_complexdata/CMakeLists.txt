cmake_minimum_required(VERSION 3.4.1)

add_library(data SHARED
           src/main/jni/data.cpp)

target_link_libraries(data
                     android
                     log)