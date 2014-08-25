$(eval $(new-module))

ifeq "$(platform)" "Darwin"
  module_cppflags += -I/Users/bsomers/cxxtest-4.4
endif

module_test := $(call glob,*.h)
module_src  := $(build_dir)/$(module_name)/runner.cpp

$(eval $(call static-dep,thermite))
$(eval $(make-program))
