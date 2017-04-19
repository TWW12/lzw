#include "decompression.h"
#include "dict.h"

int lzw_next_value;
int lzw_max = 4096;

void lzw_decompress(FILE *compressed_data, FILE *decompressed_data)
{

  init_dict();
  lzw_next_value = 256;
  int prev_value;
  int curr_value;
  int char_to_write;
  
  fscanf(compressed_data, "%d", &prev_value);
  fputc(prev_value, decompressed_data);
  
  while(!feof(compressed_data))
  {
    fscanf(compressed_data, "%d", &curr_value);
    
    if(curr_value >= lzw_next_value)
    {
      char_to_write = decode(prev_value, decompressed_data);
      fputc(char_to_write, decompressed_data);
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

int decode(int code, FILE *decompressed_data)
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
  
  fputc(char_to_write, decompressed_data);
  
  return temp;

}