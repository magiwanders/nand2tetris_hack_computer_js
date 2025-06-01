class ALU {

  // ALU is (ideally) istantaneous and has no memory. Given input, it spits out output.
  int [] out(int x, int y, int comp) {

    int out=0, zr=0, ng=0;

    // All the ALU functions.
    switch(comp) {
      case 0x2a: out = 0; break;

      case 0x3f: out = 1; break;

      case 0x3a: out = -1; break;

      case 0x0c: out = x; break;

      case 0x30: out = y; break;

      case 0x0d: out = 0xffff - x; break;

      case 0x31: out = 0xffff - y; break;

      case 0x0f: out = -x; break;

      case 0x33: out = -y; break;

      case 0x1f: out = x+1; break;

      case 0x37: out = y+1; break;

      case 0x0e: out = x-1; break;

      case 0x32: out = y-1; break;

      case 0x02: out = x+y; break;

      case 0x13: out = x-y; break;

      case 0x07: out = y-x; break;

      case 0x00: out = x&y; break;

      case 0x15: out = x|y; break;

      default: return new int[3];
    }

    // Calculate 2-complement (in case out<0)
    if (out<0) out = Default.complement2_16(out);

    // Handle overflow (clip anything over 16 bits)
    out = out & 0xffff;

    // Calculate zr and ng
    if (out==0) zr=1;
    if (out>0x8000) ng=1;


    // DEBUG
    if (Default.DEBUG) {
      println("---------ALU-IN----------");
      println("x = " + Integer.toBinaryString(x));
      println("y = " + Integer.toBinaryString(y));
      println("comp = " + Integer.toBinaryString(comp));
      println("---------ALU-OUT----------");
      println("out = " + Integer.toBinaryString(out));
      println("zr = " + Integer.toBinaryString(zr));
      println("ng = " + Integer.toBinaryString(ng));
      println("---------ALU-END----------");
    }

    int [] completeOut = {out, zr, ng};

    return completeOut;
  }

}
