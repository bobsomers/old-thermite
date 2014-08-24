#include "hello.h"

#include <string>

namespace hello {

std::string
sayHello(const std::string& who)
{
    std::string result("Hello, ");
    result.append(who);
    result += '.';
    return result;
}

} // namespace hello
