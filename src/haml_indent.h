#ifndef HAML_INDENT_H
#define HAML_INDENT_H

#ifdef __cplusplus
 extern "C" {
#endif

enum indent_type { spaces, tabs, undefined };

extern int haml_get_indent_size();
extern void haml_set_indent_size(int indent_size);
extern int haml_get_current_indent();
extern void haml_set_current_indent(int indent_size);
extern enum indent_type haml_get_indent_type();
extern void haml_set_indent_type(enum indent_type type);

extern int haml_set_space_indent(size_t indent);

#ifdef __cplusplus
 }
#endif
#endif /*HAML_INDENT_H*/

