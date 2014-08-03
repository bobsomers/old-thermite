CXXFLAGS = -I/usr/local/Cellar/glfw3/3.0.4/include
LFLAGS = -L/usr/local/Cellar/glfw3/3.0.4/lib -lglfw3

all:
	clang++ -std=c++11 -Wall $(CXXFLAGS) -o thermite thermite.cc $(LFLAGS)

clean:
	@rm -f thermite
