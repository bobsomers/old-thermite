$(eval $(new-module))

module_bin      := driver
module_cppflags := -Isrc/hello
module_dep      := $(call to-static,hello)
module_src      := $(call glob,*.cpp)

$(eval $(make-program))
