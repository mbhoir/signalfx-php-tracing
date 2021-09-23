#ifndef ZAI_HEADERS_H
#define ZAI_HEADERS_H

#include <php.h>
#include <zai_string/string.h>

#include "../zai_compat.h"

typedef enum {
    /* The header_value pointer now holds an unowned string. (no RC increase on PHP 7+) */
    ZAI_HEADER_SUCCESS,
    /* The function is being called before the _SERVER superglobal may be available. */
    ZAI_HEADER_NOT_READY,
    /* The header is not set. */
    ZAI_HEADER_NOT_SET,
    /* API usage error. */
    ZAI_HEADER_ERROR,
} zai_header_result;

#if PHP_VERSION_ID < 70000
zai_header_result zai_read_header(zai_string_view uppercase_header_name, zai_string_view *header_value TSRMLS_DC);
#else
zai_header_result zai_read_header(zai_string_view uppercase_header_name, zend_string **header_value);
#endif

#define zai_read_header_literal(uppercase_header_name, header_value) \
    zai_read_header(ZAI_STRL_VIEW(uppercase_header_name), header_value ZAI_TSRMLS_CC)

#endif  // ZAI_HEADERS_H
