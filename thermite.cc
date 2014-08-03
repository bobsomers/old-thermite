#define GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h>

#include <cstdlib>
#include <iostream>

namespace {

void
errorHandler(int error, const char* description)
{
    std::cerr << "GLFW3 ERROR: " << description << std::endl;
}

void
keyHandler(GLFWwindow* window, int key, int scancode, int action, int mods)
{
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE);
    }
}

} // namespace

int
main(int argc, char* argv[])
{
    if (!glfwInit()) {
        std::cerr << "Could not initialize GLFW3." << std::endl;
        std::exit(EXIT_FAILURE);
    }

    glfwSetErrorCallback(errorHandler);

    GLFWwindow* window = glfwCreateWindow(640, 480, "Thermite", nullptr, nullptr);
    if (!window) {
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    glfwMakeContextCurrent(window);
    glfwSetKeyCallback(window, keyHandler);

    while (!glfwWindowShouldClose(window)) {
        // TODO: All the things.
        glfwWaitEvents();
    }

    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_SUCCESS;
}
