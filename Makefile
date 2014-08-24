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
