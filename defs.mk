# System commands.
FIND  := find
MKDIR := mkdir
RM    := rm
TEST  := test
UNAME := uname

# Initialize collection variables.
binaries :=
sources  :=

# Name of the platform we're running on.
platform := $(shell $(UNAME) -s)

# Transform files from source directory paths into build directory paths.
to-build-dir = $(patsubst $(source_dir)/%,$(build_dir)/%,$1)

# Transform filenames from source files to dependency files.
to-depend = $(call to-build-dir,$(subst .cpp,.d,$1))

# Transform filenames from source files to object files.
to-object = $(call to-build-dir,$(subst .cpp,.o,$1))

# Transform binary names (given in the context of their module) into a fully
# qualified name. Intended to be called from a module.mk.
#to-binary = $(call to-build-dir,$(this-dir)/$1)
#	$1 = module
to-binary = $(build_dir)/$1/$(call $2,$1)

# Transform names into static library names.
to-static = lib$1.a

to-program = $1

# Returns a set of unique directories from a given list of files.
unique-dirs = $(sort $(dir $1))

# Returns the directory of the current Makefile this is called from.
this-dir = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Returns all files in directory $1, but not subdirectories, that match
# pattern $2. Use rglob-dir for a recursive search.
glob-dir = $(wildcard $1/$2)

# Returns all files in directory $1, and all subdirectories, that match
# pattern $2. Use glob-dir for a non-recursive search.
rglob-dir = $(shell $(FIND) "$1" -name "$2")

# Returns all files in $(this-dir), but not subdirectories, that match
# pattern $1. Use rglob for a recursive search.
glob = $(call glob-dir,$(this-dir),$1)

# Returns all files in $(this-dir), and all subdirectories, that match
# pattern $1. Use glob for a non-recursive search.
rglob = $(call rglob-dir,$(this-dir),$1)

# Creates all the unique directories from the file list passed in $1. To have
# this actually work, just call this macro and assign it to a dummy variable
# with an immediate expansion := so that the first thing make does is flesh out
# that directory structure for you.
make-dirs = $(shell                    \
  for f in $(call unique-dirs,$(1));   \
  do                                   \
    $(TEST) -d $$f || $(MKDIR) -p $$f; \
  done                                 \
)

# TODO: clears all module variables
define new-module
  module_name     := $(patsubst $(source_dir)/%,%,$(this-dir))
  module_cppflags :=
  module_dep      :=
  module_src      :=
endef

# Deduplication of macro code for creating modules. This shouldn't be invoked
# directly, but rather through make-program, make-static, etc.
# 	$1 = binary short name
# 	$2 = binary full path
# 	$3 = macro which produces the binary command to run
define make-module
  binaries += $2
  sources  += $(module_src)

  $2: $(call to-object,$(module_src)) $(module_dep)
	$(call $3)

  $1: $2

  $(build_dir)/$(module_name)/%.o: $(source_dir)/$(module_name)/%.cpp
	$(CXX) -MM -MP -MF $$(call to-depend,$$<) -MT $$@ $(CXXFLAGS) $(CPPFLAGS) $(module_cppflags) $(TARGET_ARCH) $$<
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(module_cppflags) $(TARGET_ARCH) -c -o $$@ $$<
endef

# Command to run for making a static library. This should not be invoked
# directly, but rather through make-static.
static-cmd = $(AR) $(ARFLAGS) $$@ $$^

# Command to run for making a program. This should not be invoked directly,
# but rather through make-program.
program-cmd = $(CXX) $(LDFLAGS) $(TARGET_ARCH) $$^ $(LOADLIBES) $(LDLIBS) -o $$@

static-dep = $(call to-binary,$1,to-static)

# Generates rules (which need to be eval'd) for making a static library. For
# convenience, a top level rule with the name lib$(module_name).a is created as
# well.
define make-static
  $(eval $(call make-module,$(call to-static,$(module_name))\
	                       ,$(call to-binary,$(module_name),to-static)\
                           ,static-cmd))
endef

# Generates rules (which need to be eval'd) for making a program. For
# convenience, a top level rule with the same name as $(module_name) is created
# as well.
define make-program
  $(eval $(call make-module,$(module_name)\
	                       ,$(call to-binary,$(module_name),to-program)\
                           ,program-cmd))
endef
