project (ha2er_tests)
cmake_minimum_required (VERSION 2.8)

add_subdirectory( gtest )

add_test(run.RubyTests ruby  ${CMAKE_CURRENT_SOURCE_DIR}/ruby/test_haml2erb.rb )
add_test(run.haml_c_tests ${PROJECT_BINARY_DIR}/gtest/haml_c_tests )

add_test(run.valgrind1 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest.html.haml)

add_test(run.valgrind2 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_with_id.html.haml)

add_test(run.valgrind3 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_with_id_and_hash.html.haml)

add_test(run.valgrind4 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/one_level_nested_tags.html.haml)

add_test(run.valgrind5 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/two_level_nested_tags.html.haml)

add_test(run.valgrind6 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div.html.haml)

add_test(run.valgrind7 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_static_content.html.haml)

add_test(run.valgrind8 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_ruby_content.html.haml)

add_test(run.valgrind9 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_nested_ruby_content.html.haml)

add_test(run.valgrind10 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_nested_ruby_content_and_continuation.html.haml)

add_test(run.valgrind11 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_nested_ruby_code.html.haml)

add_test(run.valgrind12 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_comment.html.haml)

add_test(run.valgrind13 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_html_comment.html.haml)

add_test(run.valgrind14 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_plain_text.html.haml)

add_test(run.valgrind15 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/simplest_div_with_escaped_plain_text.html.haml)

add_test(run.valgrind16 
    ${CMAKE_CURRENT_SOURCE_DIR}/valgrind.sh ${PROJECT_BINARY_DIR}/../src/ha2er  
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby/haml/ps_users/index.html.haml)

set (failRegex "definitely lost: [^0]")
set_tests_properties(
    run.valgrind1 
    run.valgrind2 
    run.valgrind3
    run.valgrind4
    run.valgrind5
    run.valgrind6
    run.valgrind7
    run.valgrind8
    run.valgrind9
    run.valgrind10
    run.valgrind11
    run.valgrind12
    run.valgrind14
    run.valgrind15
    run.valgrind16
    PROPERTIES
    FAIL_REGULAR_EXPRESSION "${failRegex}"
    )
