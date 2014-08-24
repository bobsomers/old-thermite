$(eval $(new-module))

module_bin := hello
module_cppflags := -DDEBUG
module_src := $(call glob,*.cpp)

$(eval $(make-static))
