#ifndef INSTRUCTION_H
#define INSTRUCTION_H

#include <QString>
#include <QVector>

class Instruction
{
public:
    Instruction(int instruction);
    int instruction, isA, isC, address, comp, dest, jump, opcode, a, c1, c2, c3, c4, c5, c6, d1, d2, d3, j1, j2, j3;
    QString error;
    bool is_a();
    bool is_c();
    int a_address(), c_comp(), c_dest(), c_jump();
    bool inst_opcode();
    int c_a(), c_c1(), c_c2(), c_c3(), c_c4(), c_c5(), c_c6(), c_d1(), c_d2(), c_d3(), c_j1(), c_j2(), c_j3();
    QVector<int> all();
};

#endif // INSTRUCTION_H
