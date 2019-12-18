cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(PoissonRecon LANGUAGES VERSION 01.00.00 CXX)

message("${PROJECT_NAME} cmake module paths: ${${PROJECT_NAME}_COLOR_BLUE}${CMAKE_MODULE_PATH}")

## Build Options ===============================================================
option(${PROJECT_NAME}_WITH_TESTS "Build ${PROJECT_NAME} library with tests" ON)
option(${PROJECT_NAME}_WITH_EXAMPLES "Build the library with UI" OFF)
# Allow the developer to select if Dynamic or Static libraries are built
option(${PROJECT_NAME}_BUILD_SHARED_LIBS "Build Shared Libraries " ON)
set(${PROJECT_NAME}_LIB_TYPE STATIC)
if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
  set(${PROJECT_NAME}_LIB_TYPE SHARED)
endif()
option(${PROJECT_NAME}_WITH_APPS "Build Apps" ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp -Wno-deprecated -std=c++11 -pthread -Wno-invalid-offsetof  -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -fPIC")

add_subdirectory(openmp)

find_package(OpenMP REQUIRED)
list(APPEND ${PROJECT_NAME}_COMPILE_DEFINITIONS ${PROJECT_NAME}_WITH_OPENMP)
list(APPEND ${PROJECT_NAME}_LINK_FLAGS ${OpenMP_CXX_FLAGS})

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/PNG ${CMAKE_CURRENT_SOURCE_DIR}/JPEG ${CMAKE_CURRENT_SOURCE_DIR}/ZLIB)

## JPEG
file(GLOB srcs "${CMAKE_CURRENT_SOURCE_DIR}/JPEG/*.h"
               "${CMAKE_CURRENT_SOURCE_DIR}/JPEG/*.cpp")

add_library(MyJPEG ${${PROJECT_NAME}_LIB_TYPE} ${srcs})

add_subdirectory(ZLIB)
add_subdirectory(PNG)

## Main library ================================================================
file(GLOB srcs "${CMAKE_CURRENT_SOURCE_DIR}/Src/*.h"
               "${CMAKE_CURRENT_SOURCE_DIR}/Src/*.inl")

set(pr_src "${CMAKE_CURRENT_SOURCE_DIR}/Src/PoissonRecon.cpp")
set(st_src "${CMAKE_CURRENT_SOURCE_DIR}/Src/SurfaceTrimmer.cpp")
set(ssd_src "${CMAKE_CURRENT_SOURCE_DIR}/Src/SSDRecon.cpp")
list(REMOVE_ITEM srcs "${pr_src}" "${st_src}" "${ssd_src}" )

add_library(${PROJECT_NAME} ${${PROJECT_NAME}_LIB_TYPE} ${srcs})
set_property(TARGET ${PROJECT_NAME} PROPERTY LINK_FLAGS ${${PROJECT_NAME}_LINK_FLAGS})
target_include_directories(${PROJECT_NAME} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/../)
target_link_libraries(${PROJECT_NAME} Ext::OpenMP MyJPEG MyPNG)
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)
## Applications ===============================================================
if(${PROJECT_NAME}_WITH_APPS)
  add_executable(PoissonReconApp ${pr_src})
  target_link_libraries(PoissonReconApp ${PROJECT_NAME} Ext::OpenMP MyJPEG MyPNG)
  set_property(TARGET PoissonReconApp PROPERTY LINK_FLAGS "${${PROJECT_NAME}_LINK_FLAGS} -lz")
  # set_property(TARGET PoissonReconApp PROPERTY COMPILE_FLAGS "-fopenmp -Wno-deprecated -std=c++11 -pthread -Wno-invalid-offsetof")
  add_executable(SurfaceTrimmer ${st_src})
  target_link_libraries(SurfaceTrimmer ${PROJECT_NAME} Ext::OpenMP MyJPEG MyPNG)
  set_property(TARGET SurfaceTrimmer PROPERTY LINK_FLAGS ${${PROJECT_NAME}_LINK_FLAGS})
endif()

## Deployment ==================================================================
install(TARGETS ${PROJECT_NAME}  PoissonReconApp SurfaceTrimmer
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  INCLUDES DESTINATION include
)
