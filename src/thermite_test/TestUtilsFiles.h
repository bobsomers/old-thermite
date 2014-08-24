#pragma once

#include "utils/files.h"

#include <cxxtest/TestSuite.h>

class TestUtilsFiles : public CxxTest::TestSuite
{
public:
    void testDirName()
    {
        TS_ASSERT_EQUALS("/usr", thm::dirName("/usr/lib"));
        TS_ASSERT_EQUALS("/", thm::dirName("/usr/"));
        TS_ASSERT_EQUALS(".", thm::dirName("usr"));
        TS_ASSERT_EQUALS("/", thm::dirName("/"));
        TS_ASSERT_EQUALS(".", thm::dirName("."));
        TS_ASSERT_EQUALS(".", thm::dirName(".."));
    }

    void testBaseName()
    {
        TS_ASSERT_EQUALS("lib", thm::dirName("/usr/lib"));
        TS_ASSERT_EQUALS("usr", thm::dirName("/usr/"));
        TS_ASSERT_EQUALS("usr", thm::dirName("usr"));
        TS_ASSERT_EQUALS("/", thm::dirName("/"));
        TS_ASSERT_EQUALS(".", thm::dirName("."));
        TS_ASSERT_EQUALS("..", thm::dirName(".."));
    }

    void testFileExtension()
    {
        TS_ASSERT(false);
    }
};
