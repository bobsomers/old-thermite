top_level_dir := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
include defs.mk

##############################################################################
#	SETTINGS

# External settings.
INSTALL_DIR ?= install

# Internal settings.
build_dir  := build
source_dir := src

# Default target is "all".
all:

##############################################################################
#	MODULES

# Include module definitions.
include src/driver/module.mk
include src/hello/module.mk

##############################################################################
#	DEPENDENCIES

# Generate our dependencies from the sources.
dependencies = $(call to-depend,$(sources))

# Only run dependency generation if our target isn't "clean".
ifneq "$(MAKECMDGOALS)" "clean"
  -include $(dependencies)
endif

##############################################################################
#	RULES

# Object files and dependencies.
$(build_dir)/%.o: $(source_dir)/%.cpp
	$(call make-depend,$<,$(call to-depend,$<),$@)
	$(call make-object,$<,$@)

##############################################################################
#	TOP LEVEL TARGETS

create_build_dirs := $(call make-dirs,$(dependencies))

.PHONY: all
all: $(binaries)

.PHONY: install
install: all

.PHONY: test
test: all

.PHONY: clean
clean:
	$(RM) -rf $(build_dir)






#CXX = clang++

#CPPREACTPATH = /home/bsomers/cpp.react

#CXXFLAGS = -I$(CPPREACTPATH)/include
#LFLAGS = -L$(CPPREACTPATH)/build/lib -lCppReact -ltbb -lGLEW -lglfw -lGL
#CXXFLAGS = -I/usr/local/Cellar/glew/1.10.0/include/GL \
#		   -I/usr/local/Cellar/glfw3/3.0.4/include
#LFLAGS = -L/usr/local/Cellar/glew/1.10.0/lib -lGLEW \
#		 -L/usr/local/Cellar/glfw3/3.0.4/lib -lglfw3 \
#		 -framework OpenGL

#all:
#	$(CXX) -std=c++11 -Wall $(CXXFLAGS) -o thermite thermite.cc $(LFLAGS)
#
#clean:
#	@rm -f thermite
