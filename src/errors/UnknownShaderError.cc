#include "thermite/errors/UnknownShaderError.h"

#include <exception>
#include <string>
#include <utility>

namespace thm {

UnknownShaderError::UnknownShaderError() noexcept :
    std::exception(),
    mShaderPath(),
    mWhatStr(),
    mWhat(nullptr)
{
}

UnknownShaderError::UnknownShaderError(std::string&& shaderPath) noexcept :
    std::exception(),
    mShaderPath(std::move(shaderPath)),
    mWhatStr(),
    mWhat(nullptr)
{
}

const std::string&
UnknownShaderError::shaderPath() const noexcept
{
    return mShaderPath;
}

const char*
UnknownShaderError::what() const noexcept
{
    if (mWhat) return mWhat;

    mWhatStr = std::string("File not found: ").append(mShaderPath);
    mWhat = mWhatStr.c_str();
    return mWhat;
}

} // namespace thm
