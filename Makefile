MODEL ?= 64
BUILD ?= debug
DPLC ?= dmd

ifneq ($(MODEL), 32)
	ifneq ($(MODEL), 64)
		$(error Unsupported architecture: $(MODEL))
	endif
endif

ifneq ($(BUILD), debug)
	ifneq ($(BUILD), release)
		$(error Unknown build mode: $(BUILD))
	endif
endif

DFLAGS = -w -wi -ignore -m$(MODEL) -of$@

ifeq ($(BUILD), release)
	DFLAGS += -release -O -inline
else
	DFLAGS += -debug -gc
endif

all: \
	bin/libffi-d.a

clean:
	-rm -f bin/*

bin/libffi-d.a: ffi.d
	-mkdir -p bin; \
	$(DPLC) $(DFLAGS) -lib ffi.d;
