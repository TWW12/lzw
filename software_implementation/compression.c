#include "compression.h"
#include "dict.h"

int lzw_next_value;
int lzw_dict_max = 4096;

void lzw_compress(FILE *uncompressed_data, FILE *compressed_data)
{

  init_dict();
  lzw_next_value = 256;
  
  int next_char;
  int prefix;
  int lzw_index;

  prefix = fgetc(uncompressed_data);

  while((next_char = fgetc(uncompressed_data)) != EOF)
  {
    
    lzw_index = dict_lookup(prefix, next_char);
    if(lzw_index != -1)
    {
      prefix = lzw_index;
    }
    else
    {
      fprintf(compressed_data, "%d ", prefix);
      if(lzw_next_value > lzw_dict_max)
      {
        increase_dict_size();
        lzw_dict_max *= 2;
      }
      dict_add(prefix, next_char, lzw_next_value);
      lzw_next_value++;
      prefix = next_char;
    
    }
    
    
  }
  fprintf(compressed_data, "%d", prefix);

}
