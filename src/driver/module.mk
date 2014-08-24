$(eval $(new-module))

module_cppflags := -Isrc/hello
module_dep      := $(call static-dep,hello)
module_src      := $(call glob,*.cpp)

$(eval $(make-program))
