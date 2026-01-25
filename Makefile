EXEC = reddust
CC = gcc
CFLAGS = -Wall -Wextra

all: $(EXEC)

$(EXEC): reddust.c
	$(CC) $(CFLAGS) reddust.c -o $(EXEC)

install:
	install -Dm755 $(EXEC) $(DESTDIR)/usr/bin/$(EXEC)

uninstall:
	rm -f /usr/bin/$(EXEC)

clean:
	rm -f $(EXEC)

