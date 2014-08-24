# System commands.
MKDIR := mkdir -p
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
