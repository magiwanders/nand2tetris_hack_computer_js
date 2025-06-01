#ifndef TEST_H
#define TEST_H

#include <cpu/pccontroller.h>
#include <utility/instruction.h>
#include "ram.h"
#include "utility/default.h"
#include <QDebug>

class Test
{
public:
    Test();
    void pccTest();
    void intructionTest();
    void cpuTest();
    void aluTest();
    void RAMTest();
};

#endif // TEST_H
