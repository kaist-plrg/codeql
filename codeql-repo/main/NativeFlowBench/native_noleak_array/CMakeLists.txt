cmake_minimum_required(VERSION 3.4.1)

add_library(noleak_array SHARED
           src/main/jni/noleak_array.cpp)

# Include libraries needed for hello-jni lib
target_link_libraries(noleak_array
                     android
                     log)