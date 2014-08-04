#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

namespace {

struct Program
{
    GLuint id;
    GLint position;
};

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

GLuint
makeShader(GLenum type, const char* filename)
{
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        std::cerr << "Failed to create shader for " << filename << std::endl;
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    std::ifstream in(filename);
    std::string shaderSrc((std::istreambuf_iterator<char>(in)),
                          std::istreambuf_iterator<char>());
    const char* src = shaderSrc.c_str();

    glShaderSource(shader, 1, &src, nullptr);
    glCompileShader(shader);

    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        std::cerr << "Failed to compile shader for " << filename << std::endl;
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            std::string infoLog(infoLen, '\0');
            glGetShaderInfoLog(shader, infoLen, nullptr, &infoLog[0]);
            std::cerr << infoLog << std::endl;
        }
        glDeleteShader(shader);
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    return shader;
}

Program
makeProgram(GLuint vertShader, GLuint fragShader)
{
    GLuint p = glCreateProgram();
    if (p == 0) {
        std::cerr << "Failed to create shader program." << std::endl;
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    glAttachShader(p, vertShader);
    glAttachShader(p, fragShader);
    glBindFragDataLocation(p, 0, "outColor");
    glLinkProgram(p);

    GLint linked = 0;
    glGetProgramiv(p, GL_LINK_STATUS, &linked);
    if (!linked) {
        std::cerr << "Failed to link program" << std::endl;
        GLint infoLen = 0;
        glGetProgramiv(p, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            std::string infoLog(infoLen, '\0');
            glGetProgramInfoLog(p, infoLen, nullptr, &infoLog[0]);
            std::cerr << infoLog << std::endl;
        }
        glDeleteProgram(p);
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    Program program;
    program.id = p;
    program.position = glGetAttribLocation(p, "position");
    return program;
}

GLuint
makeVao(GLint position)
{
    float verts[] = {
        0.0f, 0.6f,
        0.4f, -0.4f,
        -0.4f, -0.4f
    };

    GLuint vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    GLuint vbo;
    glGenBuffers(1, &vbo);

    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(verts), verts, GL_STATIC_DRAW);
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, nullptr);

    return vao;
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

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);

    GLFWwindow* window = glfwCreateWindow(640, 480, "Thermite", nullptr, nullptr);
    if (!window) {
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    glfwMakeContextCurrent(window);
    glfwSetKeyCallback(window, keyHandler);

    glewExperimental = GL_TRUE;
    GLenum err = glewInit();
    if (err != GLEW_OK) {
        std::cerr << "GLEW ERROR: " << glewGetErrorString(err) << std::endl;
        glfwTerminate();
        std::exit(EXIT_FAILURE);
    }

    Program program = makeProgram(makeShader(GL_VERTEX_SHADER, "simple.vert"),
                                  makeShader(GL_FRAGMENT_SHADER, "simple.frag"));
    GLuint vao = makeVao(program.position);

    while (!glfwWindowShouldClose(window)) {
        int width = 0;
        int height = 0;
        glfwGetFramebufferSize(window, &width, &height);
        glViewport(0, 0, width, height);

        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        glUseProgram(program.id);
        glBindVertexArray(vao);
        glDrawArrays(GL_TRIANGLES, 0, 3);

        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_SUCCESS;
}
