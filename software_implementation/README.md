This is our initial standalone software implementation of LZW compression and decompression.


Run make clean && make to build the lzw executable.


Compressing a Text File
-----------------------
./lzw -c <text_file>.txt


The compression will output a text file named 'compressed_output.txt' which contains the output of the compression algorithm.


Decompressing a Text File
-------------------------
./lzw -d compressed_output.txt

compressed_output.txt is the output from running the compression on a text file. Running the decompressing will output a text file named 'decompressed_output.txt' which will contain the result of decompressing 'compressed_output.txt'



test.txt has been provided as a sample input text that can be used to verify the compression and decompression algoirthm. If you would like to test your own input text, simply make a text file with your desired text and run it through the compression algorithm as described above. The output text file of the compression algorithm will always be 'compressed_output.txt' and the output of the decompression algorithm will always be 'decompressed_output.txt'.
