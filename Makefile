include defs.mk

##############################################################################
#	SETTINGS

# External settings.
ARFLAGS := rcs
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

##############################################################################
#	OUTPUT DIRECTORIES

create_build_dirs := $(call make-dirs,$(depends))
ifeq "$(MAKECMDGOALS)" "install"
  create_install_dirs := $(call make-dirs,$(installs))
endif

##############################################################################
#	TOP LEVEL TARGETS

.PHONY: all
all: $(binaries)

.PHONY: install
install: all $(installs)

.PHONY: test
test: all $(tests)
	@for t in $(tests); \
	do                  \
		$$t;            \
	done

.PHONY: clean
clean:
	$(RM) -rf $(build_dir) $(INSTALL_DIR)
