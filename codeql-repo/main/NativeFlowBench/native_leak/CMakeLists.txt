cmake_minimum_required(VERSION 3.4.1)

add_library(leak SHARED
           src/main/jni/leak.cpp)

target_link_libraries(leak
                     android
                     log)