class ROM {
   
  int [] rom;

  ROM() {
    rom = new_rom();
  }

  int [] new_rom() {
    return new int[Default.ROM_length];
  }

  int out(int address) {
    if(address >= 0x8000) return 0;
    return rom[address];
  }

  void flash(int [] rom) {
    for(int i=0; i<rom.length; i++) {
      this.rom[i] = rom[i];
    }
  }

  void wipe() {
    rom = new_rom();
  }

  // void read_word(int word) {
  //   return rom[word];
  // }
  //
  // void print_word(int word) {
  //   println(read_word(word));
  // }

}
