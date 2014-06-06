INSTALL=install
PREFIX=/usr
SYSCONFDIR=/etc

# Check if pkg-config is installed, we need it for building CFLAGS/LIBS
ifeq ($(shell which pkg-config 2>/dev/null 1>/dev/null || echo 1),1)
$(error "pkg-config was not found")
endif

CFLAGS += -std=c99
CFLAGS += -pipe
CFLAGS += -Wall
CPPFLAGS += -D_GNU_SOURCE
CFLAGS += $(shell pkg-config --cflags cairo xcb-dpms xcb-xinerama xkbcommon xkbfile x11 x11-xcb)
LIBS += $(shell pkg-config --libs cairo xcb-dpms xcb-xinerama xcb-image xkbcommon xkbfile x11 x11-xcb)
LIBS += -lpam
LIBS += -lev
LIBS += -lm

FILES:=$(wildcard unlock_indicator.c xinerama.c)
FILES:=$(FILES:.c=.o)

VERSION:=2.4.1
GIT_VERSION:="2.4.1 (2012-06-02)"
CPPFLAGS += -DVERSION=\"${GIT_VERSION}\"

.PHONY: install clean uninstall

all: i3lock i3lock-spy i3lock-spy-mouse i3lock-spy-panel

i3lock: i3lock.o xcb.o ${FILES}
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

i3lock-spy: i3lock-spy.o xcb.o ${FILES}
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

i3lock-spy-mouse: i3lock-spy-mouse.o xcb-mouse.o ${FILES}
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

i3lock-spy-panel: i3lock-spy-panel.o xcb-panel.o ${FILES}
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f i3lock i3lock-spy i3lock-spy-mouse i3lock-spy-panel *.o ${FILES}

install: all
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/bin
	$(INSTALL) -d $(DESTDIR)$(SYSCONFDIR)/pam.d
	$(INSTALL) -m 755 i3lock $(DESTDIR)$(PREFIX)/bin/i3lock
	$(INSTALL) -m 755 i3lock-spy $(DESTDIR)$(PREFIX)/bin/i3lock-spy
	$(INSTALL) -m 755 i3lock-spy-mouse $(DESTDIR)$(PREFIX)/bin/i3lock-spy-mouse
	$(INSTALL) -m 755 i3lock-spy-panel $(DESTDIR)$(PREFIX)/bin/i3lock-spy-panel
	$(INSTALL) -m 644 i3lock.pam $(DESTDIR)$(SYSCONFDIR)/pam.d/i3lock

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/i3lock

dist: clean
	[ ! -d i3lock-${VERSION} ] || rm -rf i3lock-${VERSION}
	[ ! -e i3lock-${VERSION}.tar.bz2 ] || rm i3lock-${VERSION}.tar.bz2
	mkdir i3lock-${VERSION}
	cp *.c *.h i3lock.1 i3lock.pam Makefile LICENSE README CHANGELOG i3lock-${VERSION}
	sed -e 's/^GIT_VERSION:=\(.*\)/GIT_VERSION:=$(shell /bin/echo '${GIT_VERSION}' | sed 's/\\/\\\\/g')/g;s/^VERSION:=\(.*\)/VERSION:=${VERSION}/g' Makefile > i3lock-${VERSION}/Makefile
	tar cfj i3lock-${VERSION}.tar.bz2 i3lock-${VERSION}
	rm -rf i3lock-${VERSION}
