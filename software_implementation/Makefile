CC     :=  gcc
CFLAGS := -pedantic -std=c99 -g
LIBS   := 
RM     := rm -f

.PHONY: all clean

NAME := lzw
SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

all: $(OBJS) $(NAME)

#
# link the .o files into the target executable
#
$(NAME): $(OBJS)
	$(CC) $^ -o $@ $(LIBS)

#
# compile the .c file into .o files using the compiler flags
#
%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@ -I.


clean:
	$(RM) *.o
	$(RM) $(NAME)
