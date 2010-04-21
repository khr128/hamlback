project (ha2er)
cmake_minimum_required (VERSION 2.8)

set (ha2er_SRCS ${PROJECT_BINARY_DIR}/lex.yy.c)

add_executable (ha2er ${ha2er_SRCS})

#Add flex library
find_library (FLEX_LIBRARY 
    NAMES fl
    PATHS /usr/lib /usr/local/lib
    )

if (FLEX_LIBRARY)
  target_link_libraries (ha2er ${FLEX_LIBRARY})
endif (FLEX_LIBRARY)

#Add custom target to build lexer
set (LEX flex)
set (LEX_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/haml2erb.fl)
add_custom_target(lex ALL
    ${LEX} ${LEX_SRCS}
    )

add_dependencies(ha2er lex)
