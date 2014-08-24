local_src := $(call glob,*.cpp)
local_dep := $(call to-static,hello)

$(eval $(call make-program,driver,$(local_src),$(local_dep)))
