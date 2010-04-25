project (ha2er_tests)
cmake_minimum_required (VERSION 2.8)

add_test(run.RubyTests ruby  ${CMAKE_CURRENT_SOURCE_DIR}/ruby/test_haml2erb.rb )
