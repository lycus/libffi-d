MODEL ?= 64
BUILD ?= debug
DPLC ?= dmd
PREFIX ?= /usr/local

ifneq ($(MODEL), 32)
	ifneq ($(MODEL), 64)
		$(error Unsupported architecture: $(MODEL))
	endif
endif

ifneq ($(BUILD), debug)
	ifneq ($(BUILD), release)
		BUILD = debug
	endif
endif

DFLAGS += -w -wi -ignore
DFLAGS += -m$(MODEL) -gc
DFLAGS += -of$@

ifeq ($(BUILD), release)
	DFLAGS += -release -O -inline
else
	DFLAGS += -debug
endif

.PHONY: all clean install uninstall

all: \
	bin/libffi-d.a

clean:
	-rm -f bin/*;

install: all
	-mkdir -p $(PREFIX);
	cp bin/libffi-d.a $(PREFIX)/lib;

uninstall: all
	if [ -d $(PREFIX) ]; then \
		rm $(PREFIX)/lib/libffi-d.a; \
	fi;

bin/libffi-d.a: ffi.d
	-mkdir -p bin;
	$(DPLC) $(DFLAGS) -lib ffi.d;
