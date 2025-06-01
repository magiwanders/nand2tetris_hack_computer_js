class PCController {

  // Helper chip that encloses the logic to calculate wether to send the jump signal to PC.
  int out(int opcode, int zr, int ng, int j1, int j2, int j3) {
    int jmp = j1 & j2 & j3;
    int jg = j3 & Default.not(zr) & Default.not(ng);
    int jl = j1 & Default.not(zr) & ng;
    int jeq = j2 & zr & Default.not(ng);
    int j = jmp | jg | jl | jeq;
    return (opcode==1) ? j : 0;
  }
}
