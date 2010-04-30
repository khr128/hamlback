#ifndef HAML_INDENT_H
#define HAML_INDENT_H

#ifdef __cplusplus
 extern "C" {
#endif

enum indent_type { spaces, tabs, undefined };
extern enum indent_type haml_indent_type;
extern int haml_indent_size;
extern int haml_current_indent;

extern int haml_set_space_indent(size_t indent);

#ifdef __cplusplus
 }
#endif
#endif /*HAML_INDENT_H*/

