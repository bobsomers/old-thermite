$(eval $(new-module))

CPPREACT_PATH ?= /home/bsomers/cpp.react

module_cppflags := -I$(CPPREACT_PATH)/include
module_ldflags := -L$(CPPREACT_PATH)/build/lib
module_ldlibs  := -lCppReact -ltbb -lGLEW -lglfw -lGL

module_src := $(call glob,*.cpp)
$(eval $(call static-dep,thermite))

$(eval $(make-program))
