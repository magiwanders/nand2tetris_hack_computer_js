#ifndef ROM_H
#define ROM_H

#include <QVector>

class ROM
{
public:
    ROM();
    QVector<int> rom;
    int output(int address);
    void flash(QVector<int> rom);
    void wipe();
};

#endif // ROM_H
