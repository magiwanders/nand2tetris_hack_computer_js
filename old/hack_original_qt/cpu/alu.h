#ifndef ALU_H
#define ALU_H

#include <QVector>


class ALU
{
public:
    ALU();
    ~ALU();
    int out, zr, ng;
    QVector <int> output(int x, int y, int comp);
};

#endif // ALU_H
