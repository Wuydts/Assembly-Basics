NAME=encyption

all: encyption

clean:
	rm -rf encyption encyption.o

encyption: encyption.asm
	nasm -f elf encyption.asm
	gcc -g -m32 -o encyption encyption.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
