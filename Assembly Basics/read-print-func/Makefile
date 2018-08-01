NAME=read-print-func

all: read-print-func

clean:
	rm -rf read-print-func read-print-func.o

read-print-func: read-print-func.asm
	nasm -f elf read-print-func.asm
	gcc -g -m32 -o read-print-func read-print-func.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
