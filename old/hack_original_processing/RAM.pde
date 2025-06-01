class RAM{
  
  int [] ram;
   
  RAM(){
    ram = new_ram();
  }
  
  int [] new_ram() {
    return new int[Default.RAM_length + Default.SCREEN_length + 1];
  } 

  int out(int in, int load, int address){
    if (address > 0x6000) return 0; // Memory addresses over KBD
    int out = ram[address];
    if (load==1) ram[address] = in;
    return out;
  }
  
  void wipe(){
    ram = new_ram();
  }
  
  void write_word(int word, int value) {
    ram[word] = value;
  }
  
  void load(int [] initialRAM) {
    for(int i=0; i<initialRAM.length; i++) {
      this.ram[i] = initialRAM[i];
    }
  }
  
  int read_KBD() {
    return ram[Default.KBD_address];
  }
  
  void write_KBD(int scancode) {
    ram[Default.KBD_address] = scancode;
  }
  
  int readPixel(int x, int y) {
    if (x>511 || y>255) return -1;
    int word = Default.SCREEN_address + ~~((y*Default.width+x)/16);
    int offset = x%16;
    int mask = 1 << offset;
    return ( ram[word] & mask ) >> offset;
  }
  
}
