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

# Transform names into static library names.
to-static = lib$1.a

# Transform names into program names.
to-program = $1

# Transform module names into binary names with the given macro.
#	$1 = module name
#	$2 = binary name macro
to-binary = $(build_dir)/$1/$(call $2,$1)

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

# Includes all modules found in $(source_dir), marked by a module.mk file.
define load-modules
  include $(call rglob-dir,$(source_dir),module.mk)
endef

# Prepares a new module by deducing its name and clearing all its variables.
define new-module
  module_name     := $(patsubst $(source_dir)/%,%,$(this-dir))
  module_dep      :=
  module_src      :=

  module_cppflags :=
  module_cxxflags :=
  module_ldflags  :=
  module_ldlibs   :=
endef

# Bakes all the module variables out with "module" replaced by the module name.
define bake-vars
  $(module_name)_cppflags := $(module_cppflags)
  $(module_name)_cxxflags := $(module_cxxflags)
  $(module_name)_ldflags  := $(module_ldflags)
  $(module_name)_ldlibs   := $(module_ldlibs)
endef

# Merges in all the flags (that make sense) from the depended-on module.
#	$1 = module name
#	$2 = binary full path macro
define make-deps
  module_dep += $(call to-binary,$1,$2)

  module_cppflags += -I$(source_dir)/$1 $$$$($1_cppflags)
  module_ldflags  += $$$$($1_ldflags)
  module_ldlibs   += $$$$($1_ldlibs)
endef

# Adds a dependency on a static library module.
# 	$1 = module name
define static-dep
  $(eval $(call make-deps,$1,to-static))
endef

# Adds a dependency on a program module.
# 	$1 = module name
define program-dep
  $(eval, $(call make-deps,$1,to-program))
endef

# Command to run for making a static library.
# 	$1 = $(module_ldflags)
# 	$2 = $(module_ldlibs)
# 	$3 = $(module_arflags)
static-cmd = $(AR) $(ARFLAGS) $3 $$@ $$^

# Command to run for making a program.
# 	$1 = $(module_ldflags)
# 	$2 = $(module_ldlibs)
# 	$3 = $(module_arflags)
program-cmd = $(CXX) $(LDFLAGS) $1 $(TARGET_ARCH) $$^ $(LOADLIBES) $(LDLIBS) $2 -o $$@

# Deduplication of macro code for creating modules. This adds their binary and
# sources to the global list, sets up a rule to build it by its explicit path
# in the build directory, sets up a convenience rule to build it by its
# binary's basename, and stamps out rules for building code from this module
# with its module-specific flags.
#
# This shouldn't be invoked directly, but rather through make-program,
# make-static, etc.
#
# 	$1 = macro that converts a module name to binary full path
# 	$2 = macro which produces the binary command to run
define make-module
  binaries += $(call to-binary,$(module_name),$1)
  sources  += $(module_src)

  $(call to-binary,$(module_name),$1): $(call to-object,$(module_src)) $(module_dep)
	$(call $2,$(module_ldflags),$(module_ldlibs),$(module_arflags))

  $(call $1,$(module_name)): $(call to-binary,$(module_name),$1)

  $(build_dir)/$(module_name)/%.o: $(source_dir)/$(module_name)/%.cpp
	$(CXX) -MM -MP -MF $$(call to-depend,$$<) -MT $$@ $(CXXFLAGS) $(module_cxxflags) $(CPPFLAGS) $(module_cppflags) $(TARGET_ARCH) $$<
	$(CXX) $(CXXFLAGS) $(module_cxxflags) $(CPPFLAGS) $(module_cppflags) $(TARGET_ARCH) -c -o $$@ $$<

  $(eval $(bake-vars))
endef

# Generates rules (which need to be eval'd) for making a static library. For
# convenience, a top level rule with the name lib$(module_name).a is created as
# well.
define make-static
  $(eval $(call make-module,to-static,static-cmd))
endef

# Generates rules (which need to be eval'd) for making a program. For
# convenience, a top level rule with the same name as $(module_name) is created
# as well.
define make-program
  $(eval $(call make-module,to-program,program-cmd))
endef
