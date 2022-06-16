#include <caml/mlvalues.h>
#include <caml/gc.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/sysctl.h>

size_t cache_line_size() {
    size_t line_size = 0;
    size_t sizeof_line_size = sizeof(line_size);
    sysctlbyname("hw.cachelinesize", &line_size, &sizeof_line_size, 0, 0);
    return line_size;
}

value caml_cache_line_size(value v) {
    return Val_int(cache_line_size());
}

value caml_aligned_int(value v) {
    size_t size = cache_line_size();
    uint64_t* x;
    posix_memalign((void**)&x, size, size);
    x[0] = Make_header(size/8, Abstract_tag, 0);
    x[1] = v;

    return (value)&(x[1]);
}

value caml_check_aligned(value v) {
    size_t size = cache_line_size();
    if (((v - 8) % size) == 0) {
        return Val_true;
    } else {
        return Val_false;
    }
}
