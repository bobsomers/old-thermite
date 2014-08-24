#include "thermite/errors/FileNotFoundError.h"

#include <exception>
#include <string>
#include <utility>

namespace thm {

FileNotFoundError::FileNotFoundError() noexcept :
    std::exception(),
    mFilePath(),
    mWhatStr(),
    mWhat(nullptr)
{
}

FileNotFoundError::FileNotFoundError(std::string&& filePath) noexcept :
    std::exception(),
    mFilePath(std::move(filePath)),
    mWhatStr(),
    mWhat(nullptr)
{
}

const std::string&
FileNotFoundError::filePath() const noexcept
{
    return mFilePath;
}

const char*
FileNotFoundError::what() const noexcept
{
    if (mWhat) return mWhat;

    mWhatStr = std::string("File not found: ").append(mFilePath);
    mWhat = mWhatStr.c_str();
    return mWhat;
}

} // namespace thm
