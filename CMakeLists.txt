cmake_minimum_required (VERSION 2.8)

enable_testing()
include( CTest )

add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/src )
add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/test )
