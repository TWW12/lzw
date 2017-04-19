/*
 * dict.h
 *
 *  Created on: Apr 2, 2017
 *      Author: Shaun
 */

#ifndef DICT_H_
#define DICT_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct dict_entry
{
  int prefix;
  int last_char;
};


void init_dict();
int dict_get_char(int lzw_dict_index);
int dict_get_prefix(int lzw_dict_index);
void dict_add(int prefix, int last_char, int lzw_dict_index);
int dict_lookup(int prefix, int next_char);
void increase_dict_size();


#endif /* DICT_H_ */
