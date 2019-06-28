.PHONY: deb install uninstall clean help build
.EXPORT_ALL_VARIABLES:

# Package version; sync with debian/control
VERSION ?= 0.1
BINDIR ?= /usr/local/bin

RULES=70-bt-reload-headphones.rules
SCRIPT=bt-reload-headphones
CONFIG=bt-reload-headphones.conf

DEBDIR=_build/bt-reload-headphones_$(VERSION)-1/

build:
	mkdir -p _build
	sh src/rules.sh > _build/$(RULES)
	cp src/$(SCRIPT) _build/
	cp src/$(CONFIG) _build/

help:
	@echo "Available targets:"
	@echo "  install   - install script and udev rule (requires root)"
	@echo "  uninstall - uninstall, if previously installed (requires root)"
	@echo "  deb       - create Debian package"
	@echo "  build     - build script and udev rules (default target)"
	@echo "  clean     - remove build files"
	@echo "  distclean - remove all generated files"
	@echo "  help      - you're reading it right now"

clean:
	rm -rf _build

distclean: clean
	rm bt-reload-headphones_*-1.deb

install: build
	install -o root -m 644 _build/$(RULES) /etc/udev/rules.d
	install -o root -m 644 _build/$(CONFIG) /etc
	install -o root -m 755 _build/$(SCRIPT) $(BINDIR)
	udevadm control --reload-rules

uninstall:
	rm /etc/udev/rules.d/$(RULES)
	rm $(BINDIR)/$(SCRIPT)
	echo "Leaving config file /etc/$(CONFIG) in place"
	udevadm control --reload-rules

deb: export BINDIR=/usr/bin
deb: clean build
	mkdir -p $(DEBDIR)/usr/bin
	mkdir -p $(DEBDIR)/etc/udev/rules.d
	mkdir -p $(DEBDIR)/DEBIAN
	install -m 644 debian/control $(DEBDIR)/DEBIAN
	install -m 644 debian/conffiles $(DEBDIR)/DEBIAN
	install -m 755 debian/postinst $(DEBDIR)/DEBIAN
	install -m 644 _build/$(RULES) $(DEBDIR)/etc/udev/rules.d
	install -m 644 _build/$(CONFIG) $(DEBDIR)/etc
	install -m 755 _build/$(SCRIPT) $(DEBDIR)/$(BINDIR)
	dpkg-deb --build $(DEBDIR)
	cp _build/*.deb ./
