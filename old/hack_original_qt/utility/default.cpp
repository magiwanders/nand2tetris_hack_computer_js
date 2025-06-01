#include "default.h"

int Default::complement2_16(int value) {
    if (value>=0) return value;
    else return (0xffff - (-value-1));
}

int Default::negate(int n) {
    if (n==0) return 1;
    else return 0;
}

int Default::readBit(int index, int source)
{
    int mask = 0x1 << index;
    return (source & mask) >> index;
}

void Default::simpleWait(uint64_t totalNanoSeconds)
{
    //totalNanoSeconds = 1000000000; // Artificially make it 1 second
    //qDebug(()totalNanoSeconds/1000000000);
    uint32_t seconds = totalNanoSeconds/1000000000;
    uint32_t nanoSeconds = totalNanoSeconds - seconds * 1000000000;
    const struct timespec rqtp = {seconds, nanoSeconds};
    nanosleep(&rqtp, NULL);
}
