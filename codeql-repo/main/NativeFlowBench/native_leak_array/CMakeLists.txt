cmake_minimum_required(VERSION 3.4.1)

add_library(leak_array SHARED
           src/main/jni/leak_array.cpp)

# Include libraries needed for hello-jni lib
target_link_libraries(leak_array
                     android
                     log)