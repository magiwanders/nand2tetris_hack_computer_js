class HackComputer {

  ROM rom = new ROM();
  CPU cpu = new CPU();
  RAM ram = new RAM();
  int inM = 0, instruction = 0, reset = 0, outM = 0, writeM = 0, addressM = 0, pc = 0;
  
  void cycle() {
    addressM = cpu.registerA;
    inM = ram.out(0, 0, addressM);
    int [][] cpuOut = cpu.out(inM, instruction, reset);
    if(reset==1) reset=0;
    outM = cpuOut[1][0];
    writeM = cpuOut[1][1];
    addressM = cpuOut[1][2];
    pc = cpuOut[1][3];
    inM = ram.out(outM, writeM, addressM);
    instruction = rom.out(pc);
  }
  
  void preload(String programName) {
    String [] programStrings = loadStrings("programs/" + programName + ".hack");
    int nTests = programStrings.length;
    int [] program = new int[nTests];
    for (int i=0; i<nTests; i++) {
      program[i]= Integer.parseInt(programStrings[i], 2);
    }
    rom.flash(program);
  }
  
  void initializeRam(int [] newRam) {
    ram.load(newRam);
  }

}
