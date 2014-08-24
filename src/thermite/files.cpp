#include "files.h"

#include <cstddef>
#include <string>

namespace {

const char PATH_SEPARATOR = '/';

}

namespace thm {

std::string
dirName(const std::string& path)
{
    return "not implemented";
}

std::string
baseName(const std::string& path)
{
    return "not implemented";
}

std::string
fileExtension(const std::string& filePath)
{
    std::size_t lastDotPos = filePath.find_last_of('.');

    if (lastDotPos == std::string::npos) {
        return std::string();
    }

    std::size_t lastPathSepPos = filePath.find_last_of(PATH_SEPARATOR);

    if (lastPathSepPos == std::string::npos) {
        return filePath.substr(lastDotPos + 1);
    }

    return "not implemented";
}

} // namespace thm
