MAKEFLAGS += -rR --no-print-directory

TARGET = INSERT_NAME_HERE

CC = gcc
CFLAGS = -Wall
CFLAGS-RELEASE = -Werror -O2
CFLAGS-DEBUG = -ggdb
CLIB =
CDEFS =

SRCS = $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

all: CFLAGS += $(CFLAGS-DEBUG)
all: $(TARGET)

x86: CFLAGS += -m32
x86: all

x64: CFLAGS += -m64
x64: all

x86-release: CFLAGS += -m32 $(CFLAGS-RELEASE)
x86-release: $(TARGET)

x64-release: CFLAGS += -m64 $(CFLAGS-RELEASE)
x64-release: $(TARGET)

depend: .depend
.depend: $(SRCS)
	@rm -f .depend
	@(for src in $^; do \
		$(CC) $(CFLAGS) $(CDEFS) -M $${src} >> .depend; \
	done; )
-include .depend

%.o: %.c
	$(CC) $(CFLAGS) $(CDEFS) -c $<

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(CLIB)

# Requires gcc-multilib
release:
	@$(MAKE) clean
	@$(MAKE) x86-release
	mv $(TARGET) $(TARGET)-x86
	strip -s $(TARGET)-x86

	@$(MAKE) smallclean
	@$(MAKE) x64-release
	mv $(TARGET) $(TARGET)-x64
	strip -s $(TARGET)-x64

	@$(MAKE) smallclean
	md5sum $(TARGET)* > MD5SUMS
	sha1sum $(TARGET)* > SHA1SUMS
	sha256sum $(TARGET)* > SHA256SUMS

tags TAGS: $(SRCS) $(wildcard *.h)
	etags $(SRCS) $(wildcard *.h)

superclean: clean
	@rm -f TAGS

clean: smallclean
	@rm -f $(TARGET) $(TARGET)-x86 $(TARGET)-x64 MD5SUMS SHA1SUMS SHA256SUMS .depend

smallclean:
	@rm -f *.o

.PHONY: all release superclean clean smallclean x86 x64 x86-release x64-release depend
