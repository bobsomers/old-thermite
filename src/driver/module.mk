local_src := $(call glob,*.cpp)

$(eval $(call make-program,coolbeans,$(local_src)))
