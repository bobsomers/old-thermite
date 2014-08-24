#include "hello/hello.h"

#include <iostream>

int
main()
{
    std::cout << hello::sayHello("driver") << std::endl;
    return 0;
}
