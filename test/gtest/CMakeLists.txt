project( haml_c_tests )
cmake_minimum_required (VERSION 2.8)
 
file ( GLOB haml_c_tests_SRCS *.cpp )

set(lib_search_paths /usr/lib /usr/local/lib)
set(gtest_lib_search_path ${lib_search_paths})
find_library(GTEST_LIB NAMES gtest PATHS ${gtest_lib_search_path})

add_executable (haml_c_tests ${haml_c_tests_SRCS} )
target_link_libraries( haml_c_tests
    ${GTEST_LIB}
    pthread
    )
