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

extern void close_previously_parsed_tags();
extern void haml_free(int n, ...);
extern void push_tag_name(char *name, char *indent);
extern char *make_tag_name(char* indent, char *name);

#ifdef __cplusplus
}
#endif
#endif /*HAML_HELPERS_H_*/
