#ifndef HAML_STRING_H_
#define HAML_STRING_H_

#ifdef __cplusplus
 extern "C" {
#endif

extern char *append(char *dst, char *src);
extern char *concatenate(int n, ...);
extern char *strtrim(char *str, char c);

#ifdef __cplusplus
}
#endif

#endif /*HAML_STRING_H_*/
