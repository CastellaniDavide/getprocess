prefix = /usr/local

all:
	$(CC) -o getprocess getprocess.c

install:
	gcc -o getprocess getprocess.c
	echo $(DESTDIR)
	echo $(prefix)
	install getprocess $(DESTDIR)$(prefix)/bin
	install getprocess.1 $(DESTDIR)$(prefix)/share/man/man1

clean:
	rm -f getprocess
