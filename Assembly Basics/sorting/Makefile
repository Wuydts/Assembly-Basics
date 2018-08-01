NAME=sorting

all: sorting

clean:
	rm -rf sorting sorting.o

sorting: sorting.asm
	nasm -f elf sorting.asm
	gcc -g -m32 -o sorting sorting.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
