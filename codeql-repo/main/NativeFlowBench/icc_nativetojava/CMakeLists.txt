cmake_minimum_required(VERSION 3.4.1)

add_library(intent SHARED
            src/main/jni/intent.cpp)

# add lib dependencies
target_link_libraries(intent
                      android
                      log)