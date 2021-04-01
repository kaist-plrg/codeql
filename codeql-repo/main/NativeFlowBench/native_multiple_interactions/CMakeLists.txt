cmake_minimum_required(VERSION 3.4.1)

add_library(multiple_interactions SHARED
           src/main/jni/multiple_interactions.cpp)

target_link_libraries(multiple_interactions
                     android
                     log)