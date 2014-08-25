$(eval $(new-module))

mdoule_cppflags := -DSHOOPDAWOOP
module_src := $(call glob,*.cpp)

$(eval $(make-static))
