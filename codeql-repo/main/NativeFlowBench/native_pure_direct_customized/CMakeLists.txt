cmake_minimum_required(VERSION 3.4.1)

# set build command
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11 -std=c++11 -fno-rtti -fno-exceptions -Wall")

# refuse to build if system level is too low
if (${ANDROID_PLATFORM_LEVEL} LESS 11)
  message(FATAL_ERROR "OpenGL 2 is not supported before API level 11 (currently using ${ANDROID_PLATFORM_LEVEL}).")
  return()
elseif (${ANDROID_PLATFORM_LEVEL} LESS 18)
  add_definitions("-DDYNAMIC_ES3")
  set(OPENGL_LIB GLESv2)
  message(STATUS "OpenGL2 ")
  message(STATUS "OpenGL2 ")
else ()
  set(OPENGL_LIB GLESv3)
  message(STATUS "OpenGL3 ")
endif (${ANDROID_PLATFORM_LEVEL} LESS 11)

add_library(native-activity SHARED
            src/main/jni/native-activity.cpp)


target_link_libraries(native-activity
                      android
                      jnigraphics
                      ${OPENGL_LIB}
                      EGL
                      log
                      m)
