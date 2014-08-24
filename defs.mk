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
# qualified name, without the $(source_dir) or $(build_dir) prefix.
#to-binary = $(patsubst $(source_dir)/%,%,$(this-dir)/$1)
to-binary = $(call to-build-dir,$(this-dir)/$1)

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

# Generates a dependency file for a source file.
# 	$1 = input source file
# 	$2 = output dependency file
# 	$3 = generated target
define make-depend
	$(CXX) -MM -MP -MF $2 -MT $3 $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) $1
endef

# Generates an object file for a source file.
#	$1 = input source file
#	$2 = output object file
define make-object
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) $ -c -o $2 $1
endef

# Generates rules (which need to be eval'd) for making a program. For
# convenience, a top level rule with the same name as the binary is created
# as well.
define make-program
  binaries += $(call to-binary,$1)
  sources  += $2

  $(call to-binary,$1): $(call to-object,$2)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $$^ $(LOADLIBES) $(LDLIBS) -o $$@

  $1: $(call to-binary,$1)
endef
