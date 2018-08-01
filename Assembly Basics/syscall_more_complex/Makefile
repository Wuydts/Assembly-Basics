NAME=syscall_hw

all: syscall_hw

clean:
	rm -rf syscall_hw syscall_hw.o

syscall_hw: syscall_hw.asm
	nasm -f elf syscall_hw.asm
	gcc -g -m32 -o syscall_hw syscall_hw.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
