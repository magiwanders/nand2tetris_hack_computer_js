#include "ram.h"
#include "utility/default.h"

#include <qdebug.h>

RAM::RAM()
{
    ram = QVector<int>(Default::RAM_length + Default::SCREEN_length + 1);
}

int RAM::output(int in, int load, int address)
{
    if (address > 0x6000) return 0; // Memory addresses over KBD
    int out = ram[address];
    if (load==1) ram[address] = in;
    return out;
}

void RAM::wipe(){
    ram = QVector<int>(Default::RAM_length + Default::SCREEN_length + 1);
}

void RAM::write_word(int word, int value) {
    ram[word] = value;
}

void RAM::load(QVector<int> initialRAM) {
    ram = initialRAM;
}

int RAM::read_KBD() {
  return ram[Default::KBD_address];
}

void RAM::write_KBD(int scancode) {
  ram[Default::KBD_address] = scancode;
}

int RAM::readPixel(int x, int y) {
  if (x>511 || y>255) return -1;
  int word = Default::SCREEN_address + ~~((y*Default::width+x)/16);
  int offset = x%16;
  int mask = 1 << offset;
  return ( ram[word] & mask ) >> offset;
}
