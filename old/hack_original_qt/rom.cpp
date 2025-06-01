#include "rom.h"
#include "utility/default.h"

ROM::ROM()
{
    rom = QVector<int>(Default::ROM_length);
}

int ROM::output(int address)
{
    if(address >= 0x8000) return 0;
    return rom[address];
}

void ROM::flash(QVector<int> rom)
{
    for(int i=0; i<sizeof(rom)/4; i++) {
      this->rom[i] = rom[i];
    }
}

void ROM::wipe()
{
    rom = QVector<int>(Default::ROM_length);
}
