#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compression.h"
#include "decompression.h"
#include "dict.h"

FILE *input_data;
FILE *output_data;


int main(int argc, char** argv)
{

  if(argc > 2)
  {
    if(strcmp(argv[1], "-c") == 0) 
    {
      printf("Compression\n");
      input_data = fopen(argv[2], "r");
      output_data = fopen("compressed_output.txt", "w+");
      lzw_compress(input_data, output_data); 
      fclose(input_data);
      fclose(output_data);
    }
    else if(strcmp(argv[1], "-d") == 0)
    {
      printf("Decompression\n");
      input_data = fopen(argv[2], "r");
      output_data = fopen("decompressed_output.txt", "w+");
      lzw_decompress(input_data, output_data);
      fclose(input_data);
      fclose(output_data);
    }
    else
    {
      printf("Invalid command, exiting\n");
      return 0;
    }
  }
  else
  {
    printf("Invalid number of arguements\n");
    printf("Compression usage: ./lzw -c uncompressed_data.txt\n");
    printf("Decompression usage: ./lzw -d compressed_data.txt\n");
    return 0;
  }

  return 0;

}
