#include "Shader.h"

#include "InvalidShaderError.h"
#include "thmgl.h"
#include "utils.h"

#include <string>
#include <utility>

namespace thm {

Shader::Shader(std::string filePath) :
    GLuint mHandle(0),
    GLenum mType(0),
    mFilePath(std::move(filePath))
{
    // Determine the shader type based on the file extension.
    if (mFilePath.size() < 3) {
        throw InvalidShaderError(makeStr("File '", mFilePath,
                "' is not a valid shader type"));
    }

    // TODO
}

Shader::~Shader()
{
    // TODO
}

} // namespace thm
