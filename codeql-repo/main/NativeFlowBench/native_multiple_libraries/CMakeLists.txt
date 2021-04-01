cmake_minimum_required(VERSION 3.4.1)

add_library(master SHARED
           src/main/jni/master.cpp)

add_library(foo SHARED
           src/main/jni/foo.cpp)

target_link_libraries(master
                     android
                     log)

target_link_libraries(foo
                     android
                     log)