NAME=syscall

all: syscall

clean:
	rm -rf syscall syscall.o

syscall: syscall.asm
	nasm -f elf syscall.asm
	gcc -g -m32 -o syscall syscall.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
