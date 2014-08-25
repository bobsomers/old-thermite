$(eval $(new-module))

module_test := $(call glob,*.h)
module_src := $(build_dir)/$(module_name)/runner.cpp
$(eval $(call static-dep,thermite))

$(eval $(make-program))
