NAME=randomgen

all: randomgen

clean:
	rm -rf randomgen randomgen.o

randomgen: randomgen.asm
	nasm -f elf randomgen.asm
	gcc -g -m32 -o randomgen randomgen.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
