#pragma once

#include <string>

namespace thm {

// Returns the leading path up until the last component. The trailing path
// separator is not included. (See UNIX dirname() function.)
std::string
dirName(const std::string& path);

// Returns the trailing path including only the last path component. The
// leading path separator is not included. (See UNIX basename() function.)
std::string
baseName(const std::string& path);

// Returns the file extension (after the last '.') of the given file path, or
// the empty string if there is no extension.
std::string
fileExtension(const std::string& filePath);

} // namespace thm
