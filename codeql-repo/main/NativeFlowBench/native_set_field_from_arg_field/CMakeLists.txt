cmake_minimum_required(VERSION 3.4.1)

add_library(set_field_from_arg_field SHARED
           src/main/jni/set_field_from_arg_field.cpp)

target_link_libraries(set_field_from_arg_field
                     android
                     log)