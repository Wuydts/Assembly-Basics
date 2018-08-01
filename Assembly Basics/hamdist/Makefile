NAME=hamdist

all: hamdist

clean:
	rm -rf hamdist hamdist.o

hamdist: hamdist.asm
	nasm -f elf hamdist.asm
	gcc -g -m32 -o hamdist hamdist.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
