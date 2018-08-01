NAME=push-pop

all: push-pop

clean:
	rm -rf push-pop push-pop.o

push-pop: push-pop.asm
	nasm -f elf push-pop.asm
	gcc -g -m32 -o push-pop push-pop.o /usr/share/csc314/driver.c /usr/share/csc314/asm_io.o
