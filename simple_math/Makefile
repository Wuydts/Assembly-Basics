NAME=simple_math

all: simple_math

clean:
	rm -rf simple_math simple_math.o

simple_math: simple_math.asm
	nasm -f elf simple_math.asm
	gcc -g -m32 -o simple_math simple_math.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
