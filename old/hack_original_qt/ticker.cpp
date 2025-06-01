#include "ticker.h"
#include "hackcomputerqt.h"
#include "utility/default.h"

#include <iostream>

void Ticker::run()
{
    while(true) {
        hackComputer->cycle();
        Default::simpleWait( (uint64_t) 1000000000/(Default::MHZ*1000000));
//        qDebug() << "----------------------------";
//        qDebug() << hackComputer->cpu->Pc->pc;
//        qDebug() << hackComputer->cpu->registerA;
//        qDebug() << hackComputer->cpu->writeM;
//        qDebug() << hackComputer->cpu->registerD;
//        qDebug() << hackComputer->ram->ram[0];
//        qDebug() << "----------------------------";
    }
}

Ticker::Ticker(HackComputer *hackComputer)
{
    this->hackComputer = hackComputer;
}
