CC = gcc
CFLAGS = -Wall -m64

all: main.o wielomian.o
	$(CC) $(CFLAGS) -o run main.o wielomian.o `allegro-config --shared`

wielomian.o: wielomian.s
	nasm -f elf64 -o wielomian.o wielomian.s

main.o: main.c wielomian.h
	$(CC) $(CFLAGS) -c -o main.o main.c

clean:
	rm -f *.o

