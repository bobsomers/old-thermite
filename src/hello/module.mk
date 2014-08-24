$(eval $(new-module))

module_cppflags := -DHELLO
module_src      := $(call glob,*.cpp)

$(eval $(make-static))
