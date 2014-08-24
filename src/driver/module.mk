$(eval $(new-module))

module_src := $(call glob,*.cpp)
$(eval $(call static-dep,hello))

$(eval $(make-program))
