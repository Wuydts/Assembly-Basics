NAME=variables_and_memory

all: variables_and_memory

clean:
	rm -rf variables_and_memory variables_and_memory.o

variables_and_memory: variables_and_memory.asm
	nasm -f elf variables_and_memory.asm
	gcc -g -m32 -o variables_and_memory variables_and_memory.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
