#pragma once

#include <string>

namespace thm {

namespace detail {

// Disambiguates output string of makeStrImpl() from std::string arguments.
struct StringWrapper
{
    std::string s;
};

// Base case for function template recursion.
inline void
makeStrImpl(StringWrapper&)
{ 
}

// Overload to handle char* arguments.
template <typename... Rest>
inline void
makeStrImpl(StringWrapper& sw, const char* value, const Rest&... rest)
{
    sw.s.append(value);
    makeStrImpl(sw, rest...);
}

// Overload to handle std::string arguments.
template <typename... Rest>
inline void
makeStrImpl(StringWrapper& sw, const std::string& value, const Rest&... rest)
{
    sw.s.append(value);
    makeStrImpl(sw, rest...);
}

// General case, which handles any type with to_string defined.
template <typename First, typename... Rest>
inline void
makeStrImpl(StringWrapper& sw, const First& value, const Rest&... rest)
{
    using std::to_string;
    sw.s.append(to_string(value));
    makeStrImpl(sw, rest...);
}

} // namespace detail

// Builds a std::string from all of the passed arguments. For arguments which
// are not of char* or std::string type, the free function to_string() is
// invoked on them.
template <typename... T>
std::string
makeStr(const T&... value)
{
    detail::StringWrapper sw;
    detail::makeStrImpl(sw, value...);
    return sw.s;
}

} // namespace thm
