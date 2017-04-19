/*
 * decompression.h
 *
 *  Created on: Apr 2, 2017
 *      Author: Shaun
 */

#ifndef DECOMPRESSION_H_
#define DECOMPRESSION_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void lzw_decompress(int* compressed_data, int size, char *decompressed_data);
int decode(int code, char *decompressed_data);


#endif /* DECOMPRESSION_H_ */
