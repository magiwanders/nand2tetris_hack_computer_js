#ifndef HACKCOMPUTER_H
#define HACKCOMPUTER_H

#include "cpu/cpu.h"
#include "rom.h"
#include "ram.h"

#include <QString>
#include <iostream>
#include <qgraphicsscene.h>

class HackComputer
{
public:
    HackComputer();
    ~HackComputer();
    CPU * cpu;
    RAM * ram;
    ROM * rom;
    QVector<QVector<int>> cpuOut;
    int inM = 0, instruction = 0, reset = 0, outM = 0, writeM = 0, addressM = 0, pc = 0;
    void cycle();
    void preload(QString programName);
    void initializeRam(QVector<int> newRam);
};

#endif // HACKCOMPUTER_H
