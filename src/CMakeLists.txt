project (ha2er)
cmake_minimum_required (VERSION 2.8)

set (hamlparser_SRCS
      ${CMAKE_CURRENT_SOURCE_DIR}/haml_stack.c
      ${CMAKE_CURRENT_SOURCE_DIR}/haml_indent.c
      ${CMAKE_CURRENT_SOURCE_DIR}/haml_continuation.c
      ${CMAKE_CURRENT_SOURCE_DIR}/haml_string.c
      ${CMAKE_CURRENT_SOURCE_DIR}/haml_helpers.c
    )
add_library (hamlparser STATIC ${hamlparser_SRCS})

#Add custom target to build lexer
set (LEX flex)
set (LEX_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/haml2erb.fl)
add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/haml2erb.scanner.c
    DEPENDS  ${LEX_SRCS}
    COMMAND  ${LEX}
    ARGS     ${LEX_SRCS}
    )

add_custom_target(lex ALL
    DEPENDS ${PROJECT_BINARY_DIR}/haml2erb.scanner.c
    )

#Add custom target to build grammar
set (YACC bison)
set (YACC_OPTS -d -v)
set (YACC_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/haml2erb.y)
add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/haml2erb.tab.c
    DEPENDS  ${YACC_SRCS}
    COMMAND  ${YACC} ${YACC_OPTS}
    ARGS     ${YACC_SRCS}
    )

add_custom_target(yacc ALL
    DEPENDS ${PROJECT_BINARY_DIR}/haml2erb.tab.c
    )

set (ha2er_SRCS 
    ${PROJECT_BINARY_DIR}/haml2erb.scanner.c 
    ${PROJECT_BINARY_DIR}/haml2erb.tab.c
    )

include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )

add_executable (ha2er ${ha2er_SRCS})
target_link_libraries (ha2er hamlparser)
#Add flex library
find_library (FLEX_LIBRARY 
    NAMES fl
    PATHS /usr/lib /usr/local/lib
    )

if (FLEX_LIBRARY)
  target_link_libraries (ha2er ${FLEX_LIBRARY})
endif (FLEX_LIBRARY)

add_dependencies(lex yacc)
add_dependencies(ha2er hamlparser lex)
