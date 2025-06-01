#ifndef CPU_H
#define CPU_H

#include "alu.h"
#include "pc.h"
#include "pccontroller.h"

#include <QVector>

class CPU
{
public:
    CPU();
    ~CPU();
    ALU * alu;
    PC * Pc;

    //QVector<int> outAlu;
    QVector<int> outPC;

    int registerD, registerA, outM, writeM, addressM, pc, inA, loadA, loadD, outAlu, x, y, zr, ng, jump;
    QVector<QVector<int>> output(int inM, int instruction, int reset);
};

#endif // CPU_H
