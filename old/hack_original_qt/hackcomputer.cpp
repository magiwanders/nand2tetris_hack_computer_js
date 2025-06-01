#include "hackcomputer.h"

#include <QFile>
#include <QTextStream>
#include <qdebug.h>

HackComputer::HackComputer()
{
    cpu = new CPU();
    ram = new RAM();
    rom = new ROM();
}

HackComputer::~HackComputer()
{
    delete cpu;
    delete ram;
    delete rom;
}

void HackComputer::cycle()
{
    qDebug() << "-----------------------";
    qDebug() << "pc = " << pc;
    qDebug() << "regA = " << cpu->registerA;
    qDebug() << "writeM = " << cpu->writeM;
    qDebug() << "regD = " << cpu->registerD;
    //qDebug() << ram->ram[0];

    addressM = cpu->registerA;
    inM = ram->output(0, 0, addressM);
    cpuOut = cpu->output(inM, instruction, reset);
    if(reset==1) reset=0;
    outM = cpuOut[1][0];
    writeM = cpuOut[1][1];
    addressM = cpuOut[1][2];
    pc = cpuOut[1][3];
    inM = ram->output(outM, writeM, addressM);
    instruction = rom->output(pc);
}

void HackComputer::preload(QString programName)
{
    QFile file("programs/" + programName + ".hack");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "programs/" + programName + ".hack";
        qDebug() << "Program file not found!";
        exit(EXIT_FAILURE);
    }
    QTextStream in(&file);
    for (int i=0; !in.atEnd(); i++) {
        int line = in.readLine().toInt(NULL, 2);
        //qDebug() << line;
        rom->rom[i] = line;
    }
}

void HackComputer::initializeRam(QVector<int> newRam)
{
    ram->load(newRam);
}
