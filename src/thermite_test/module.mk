$(eval $(new-module))

ifeq "$(platform)" "Darwin"
  CXXTEST_PATH ?= /Users/bsomers/cxxtest-4.4
else ifeq "$(platform)" "Linux"
  CXXTEST_PATH ?=
else
  $(error Platform not supported)
endif

module_cppflags := -I$(CXXTEST_PATH)

module_test := $(call glob,*.h)
module_src  := $(build_dir)/$(module_name)/runner.cpp

$(eval $(call static-dep,thermite))
$(eval $(make-program))
