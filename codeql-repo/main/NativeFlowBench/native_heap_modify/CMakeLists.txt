cmake_minimum_required(VERSION 3.4.1)

add_library(heap_modify SHARED
           src/main/jni/heap_modify.cpp)

target_link_libraries(heap_modify
                     android
                     log)