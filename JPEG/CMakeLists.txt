
project(JPEG LANGUAGES VERSION 01.00.00 CXX)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-deprecated -Wno-write-strings")

file(GLOB srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
               "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_library(MyJPEG ${${PROJECT_NAME}_LIB_TYPE} ${srcs})
target_link_libraries(MyJPEG)
