#ifndef PC_H
#define PC_H

#include <QVector>


class PC
{
public:
    PC();
    int pc;
    QVector<int> output(int in, int reset, int load, int inc);
};

#endif // PC_H
