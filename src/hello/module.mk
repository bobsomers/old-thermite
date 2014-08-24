$(eval $(new-module))

module_src      := $(call glob,*.cpp)

$(eval $(make-static))
