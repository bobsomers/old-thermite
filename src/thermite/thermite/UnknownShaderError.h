#pragma once

#include <exception>
#include <string>

namespace thm {

class UnknownShaderError : public std::exception
{
public:
    UnknownShaderError() noexcept;
    explicit UnknownShaderError(std::string&& shaderPath) noexcept;

    UnknownShaderError(const UnknownShaderError&) = default;
    UnknownShaderError& operator=(const UnknownShaderError&) = default;

    UnknownShaderError(UnknownShaderError&&) = default;
    UnknownShaderError& operator=(UnknownShaderError&&) = default;

    ~UnknownShaderError() noexcept = default;

    const std::string& shaderPath() const noexcept;
    virtual const char* what() const noexcept;

private:
    std::string mShaderPath;
    mutable std::string mWhatStr;
    mutable const char* mWhat;
};

} // namespace thm
