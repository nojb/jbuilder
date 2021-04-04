#include <stdio.h>

#include "xxh3.h"

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>

value dune__xxhash_string(value str)
{
  CAMLparam1(str);
  XXH32_hash_t hash = XXH32(String_val(str), caml_string_length(str), 0);
  CAMLreturn(caml_copy_int32(hash));
}

#define BUFFER_SIZE 4096

value dune__xxhash_file(value path)
{
  CAMLparam1(path);
  char buffer[BUFFER_SIZE];
  FILE *fd;
  XXH32_state_t *state = XXH32_createState();
  if (state == NULL) {
    caml_failwith("XXH32_createState()");
  }
  if (XXH32_reset(state, 0) == XXH_ERROR) {
    XXH32_freeState(state);
    caml_failwith("XXH32_reset()");
  }
  fd = fopen(String_val(path), "rb");
  while (1) {
    size_t n = fread(buffer, 1, BUFFER_SIZE, fd);
    if (n == 0) break;
    if (XXH32_update(state, buffer, n) == XXH_ERROR) {
      caml_failwith("XXH32_update()");
    }
  }
  fclose(fd);
  XXH32_hash_t hash = XXH32_digest(state);
  XXH32_freeState(state);
  CAMLreturn(caml_copy_int32(hash));
}
