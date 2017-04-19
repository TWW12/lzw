#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void lzw_decompress(FILE *compressed_data, FILE *decompressed_data);
int decode(int code, FILE *decompressed_data);
