#pragma once

#include <exception>
#include <string>

namespace thm {

class FileNotFoundError : public std::exception
{
public:
    FileNotFoundError() noexcept;
    explicit FileNotFoundError(std::string&& filePath) noexcept;

    FileNotFoundError(const FileNotFoundError&) = default;
    FileNotFoundError& operator=(const FileNotFoundError&) = default;

    FileNotFoundError(FileNotFoundError&&) = default;
    FileNotFoundError& operator=(FileNotFoundError&&) = default;

    ~FileNotFoundError() noexcept = default;

    const std::string& filePath() const noexcept;
    virtual const char* what() const noexcept;

private:
    std::string mFilePath;
    mutable std::string mWhatStr;
    mutable const char* mWhat;
};

} // namespace thm
