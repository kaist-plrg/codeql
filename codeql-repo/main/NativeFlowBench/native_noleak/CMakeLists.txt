cmake_minimum_required(VERSION 3.4.1)

add_library(noleak SHARED
           src/main/jni/noleak.cpp)

# Include libraries needed for hello-jni lib
target_link_libraries(noleak
                     android
                     log)