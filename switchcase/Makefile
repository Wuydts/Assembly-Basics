NAME=switchcase

all: switchcase

clean:
	rm -rf switchcase switchcase.o

switchcase: switchcase.asm
	nasm -f elf switchcase.asm
	gcc -g -m32 -o switchcase switchcase.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
