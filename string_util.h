#ifndef STRING_UTIL_H
#define STRING_UTIL_H

extern int allocations;
char *string_dup(char *str);
void string_free(const char *ptr);
char *string_merge(const char *str1, const char *str2, const char *str3);

#endif //STRING_UTIL_H