include defs.mk

##############################################################################
#	SETTINGS

# External settings.
CXXFLAGS ?= -std=c++11 -Wall
INSTALL_DIR ?= install

# Internal settings.
build_dir  := build
source_dir := src

# Default target is "all".
all:

##############################################################################
#	MODULES

$(eval $(load-modules))

##############################################################################
#	DEPENDENCIES

# Generate dependency information from the sources and flesh out the build_dir.
depends = $(call to-depend,$(sources))
-include $(depends)
create_build_dirs := $(call make-dirs,$(depends))

##############################################################################
#	TOP LEVEL TARGETS

.PHONY: all
all: $(binaries)

.PHONY: install
install: all

.PHONY: test
test: all

.PHONY: clean
clean:
	$(RM) -rf $(build_dir)
