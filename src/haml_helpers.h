#ifndef HAML_HELPERS_H_
#define HAML_HELPERS_H_

#ifdef __cplusplus
 extern "C" {
#endif
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "haml_string.h"
#include "haml_stack.h"
#include "haml_indent.h"
#include "haml_continuation.h"

extern void close_previously_parsed_tags(const char* new_tag);
extern void haml_free(int n, ...);
extern void push_tag_name(char *name, char *indent, enum tag_type type);
extern char *make_tag_name(char *name, char* indent);
extern char* print_indented_tag(char *match, char* tokens, const char *code_fmt, const char *trim);
extern void check_previous_tag();
extern char* make_tag_element(char *el, int* just_indent, char *acc);

#ifdef __cplusplus
}
#endif
#endif /*HAML_HELPERS_H_*/
