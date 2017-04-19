/*
 * decompression.c
 *
 *  Created on: Apr 2, 2017
 *      Author: Shaun
 */


#include "decompression.h"
#include "dict.h"

int lzw_next_value;
int lzw_max = 4096;
int decompressed_index = 0;

void lzw_decompress(int* compressed_data, int size, char *decompressed_data)
{

  init_dict();
  lzw_next_value = 256;
  int prev_value;
  int curr_value;
  int char_to_write;
  int i;



  prev_value = compressed_data[0];
  decompressed_data[decompressed_index] = prev_value;
  decompressed_index++;


  for(i=1; i<size; i++)
  {
    curr_value = compressed_data[i];

    if(curr_value >= lzw_next_value)
    {
      char_to_write = decode(prev_value, decompressed_data);

      decompressed_data[decompressed_index] = char_to_write;
      decompressed_index++;
    }
    else
    {
      char_to_write = decode(curr_value, decompressed_data);
    }

    if(lzw_next_value > lzw_max)
    {
      increase_dict_size();
      lzw_max *= 2;
    }
    dict_add(prev_value, char_to_write, lzw_next_value);
    lzw_next_value++;

    prev_value = curr_value;

  }

}

int decode(int code, char *decompressed_data)
{

  int char_to_write;
  int temp;

  if(code > 255)
  {
    char_to_write = dict_get_char(code);
    temp = decode(dict_get_prefix(code), decompressed_data);
  }
  else
  {
    char_to_write = code;
    temp = code;
  }
  decompressed_data[decompressed_index] = char_to_write;
  decompressed_index++;


  return temp;

}
