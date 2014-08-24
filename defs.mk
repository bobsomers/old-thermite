# System commands.
FIND  := find
MKDIR := mkdir
RM    := rm
TEST  := test
UNAME := uname

# Name of the platform we're running on.
platform := $(shell $(UNAME) -s)

# Transform files from source directory paths into build directory paths.
to-build-dir = $(patsubst $(source_dir)/%,$(build_dir)/%,$1)

# Transform filenames from source files to dependency files.
to-depend = $(call to-build-dir,$(subst .cpp,.d,$1))

# Transform filenames from source files to object files.
to-object = $(call to-build-dir,$(subst .cpp,.o,$1))

# Returns a set of unique directories from a given list of files.
unique-dirs = $(sort $(dir $1))

# Returns the directory of the current Makefile this is called from.
this-dir = $(dir $(lastword $(MAKEFILE_LIST)))

# Returns all files in directory $1, but not subdirectories, that match
# pattern $2. Use glob-deep for a recursive search.
glob-once = $(wildcard $1/$2)

# Returns all files in directory $1, and all subdirectories, that match
# pattern $2. Use glob-once for a non-recursive search.
glob-deep = $(shell $(FIND) "$1" -name "$2")

# Creates all the unique directories from the file list passed in $1. To have
# this actually work, just call this macro and assign it to a dummy variable
# with an immediate expansion := so that the first thing make does is flesh out
# that directory structure for you.
make-skeleton-dirs = $(shell           \
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
