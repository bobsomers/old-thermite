$(eval $(new-module))

ifeq "$(platform)" "Darwin"
  CPPREACT_PATH ?= /Users/bsomers/cpp.react
else ifeq "$(platform)" "Linux"
  CPPREACT_PATH ?= /home/bsomers/cpp.react
else
  $(error Platform not supported)
endif

module_cppflags := -I$(CPPREACT_PATH)/include
module_ldflags := -L$(CPPREACT_PATH)/build/lib
module_ldlibs  := -lCppReact -ltbb -lGLEW -lglfw -lGL

module_src := $(call glob,*.cpp)
$(eval $(call static-dep,thermite))

$(eval $(make-program))
