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

DFLAGS = -w -wi -ignore -m$(MODEL) -of$@

ifeq ($(BUILD), release)
	DFLAGS += -release -O -inline
else
	DFLAGS += -debug -gc
endif

.PHONY: all clean install

all: \
	bin/libffi-d.a

clean:
	-rm -f bin/*;

install: all
	-mkdir -p $(PREFIX);
	cp bin/libffi-d.a $(PREFIX)/lib;

bin/libffi-d.a: ffi.d
	-mkdir -p bin;
	$(DPLC) $(DFLAGS) -lib ffi.d;
