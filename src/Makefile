PREFIX ?= /usr/local

.PHONY: build
build:
	gcc -o hello hello.c

.PHONY: install
install: build
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp hello $(DESTDIR)$(PREFIX)/bin/

.PHONY: clean
clean:
	rm -f hello