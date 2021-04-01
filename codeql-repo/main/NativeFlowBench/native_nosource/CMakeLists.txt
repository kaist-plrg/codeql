cmake_minimum_required(VERSION 3.4.1)

add_library(nosource SHARED
           src/main/jni/nosource.cpp)

target_link_libraries(nosource
                     android
                     log)