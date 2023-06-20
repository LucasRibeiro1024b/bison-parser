#include <string.h>
#include <stdlib.h>
#include "string_util.h"

int allocations = 0;

char *string_dup(char *str) {
    allocations++;
    return strdup(str);
}

void string_free(const char *ptr) {
    allocations--;
    free((void *)ptr);
}

char *string_merge(const char *str1, const char *str2, const char *str3) {
    size_t len = strlen(str1) + strlen(str2) + strlen(str3) + 1;
    char *ptr = malloc(len);
    allocations++;
    strcpy(ptr, str1);
    strcat(ptr, str2);
    strcat(ptr, str3);
    string_free(str1);
    string_free(str2);
    string_free(str3);
    return ptr;
}