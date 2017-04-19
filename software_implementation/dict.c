#include "dict.h"

struct dict_entry *lzw_dict;

int lzw_dict_size;

int lzw_dict_max_size = 4096;

void init_dict()
{
  lzw_dict = malloc(4096*sizeof(struct dict_entry));
  int i;
  for(i=0; i<256; i++)
  {
    lzw_dict[i].prefix = -1;
    lzw_dict[i].last_char = i;
  }
   lzw_dict_size = 256;
   

}


int dict_get_char(int lzw_dict_index)
{

  return lzw_dict[lzw_dict_index].last_char;

}

int dict_get_prefix(int lzw_dict_index)
{

  return lzw_dict[lzw_dict_index].prefix;

}



void dict_add(int prefix, int last_char, int lzw_dict_index)
{

  lzw_dict[lzw_dict_index].prefix = prefix;
  lzw_dict[lzw_dict_index].last_char = last_char;
  lzw_dict_size++;

}


int dict_lookup(int prefix, int next_char)
{

  int i;
  for(i=0; i<lzw_dict_size; i++)
  {
    if(lzw_dict[i].prefix == prefix && lzw_dict[i].last_char == next_char)
    {
      return i;
    }
  }
  return -1;

}

void increase_dict_size()
{
  lzw_dict_max_size *= 2;
  struct dict_entry *temp = realloc(lzw_dict, lzw_dict_max_size*sizeof(lzw_dict));
  lzw_dict = temp;
}