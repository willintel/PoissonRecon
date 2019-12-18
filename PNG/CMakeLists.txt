
project(PoissonRecon LANGUAGES VERSION 01.00.00 C)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-deprecated -Wno-write-strings -lz")

file(GLOB srcs "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
               "${CMAKE_CURRENT_SOURCE_DIR}/*.c")

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_library(MyPNG ${${PROJECT_NAME}_LIB_TYPE} ${srcs})
# set_target_properties(MyPNG PROPERTIES LINKER_LANGUAGE CXX)
# set_target_properties(MyPNG PROPERTIES IMPORTED_GLOBAL TRUE)
