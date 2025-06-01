// This is an utility of static methods that help the decoding of instructions

class Instruction {

  int instruction, isA, isC, address, comp, dest, jump, opcode, a, c1, c2, c3, c4, c5, c6, d1, d2, d3, j1, j2, j3;
  String error;
  
  Instruction(int instruction) {
    this.instruction = instruction;
    isA = is_a() ? 1 : 0;
    isC = is_c() ? 1 : 0;
    if (isA==0 && isC==0) error = "error";

    // Components
    address = a_address();
    comp = c_comp();
    dest = c_dest();
    jump = c_jump();

    // Bits
    opcode = inst_opcode() ? 1 : 0;
    a = c_a();
    c1 = c_c1();
    c2 = c_c2();
    c3 = c_c3();
    c4 = c_c4();
    c5 = c_c5();
    c6 = c_c6();
    d1 = c_d1();
    d2 = c_d2();
    d3 = c_d3();
    j1 = c_j1();
    j2 = c_j2();
    j3 = c_j3();
  }

  boolean is_a() {
    return instruction < 0x8000;
  }

  boolean is_c() {
    return instruction >= 0xe000;
  }


  // Components

  int a_address() {
    if(is_a()) return instruction;
    else return -1;
  }

  int c_comp() {
    int mask = 0x7f << 6;
    return ( instruction & mask ) >> 6;
  }

  int c_dest() {
    int mask = 0x7 << 3;
    return ( instruction & mask ) >> 3;
  }

  int c_jump() {
    int mask = 0x7;
    return ( instruction & mask );
  }


  // Bits

  boolean inst_opcode() {
    return instruction >= 0x8000;
  }

  int c_a() {
    return Default.readBit(6, c_comp());
  }

  int c_c1() {
    return Default.readBit(5, c_comp());
  }

  int c_c2() {
    return Default.readBit(4, c_comp());
  }

  int c_c3() {
    return Default.readBit(3, c_comp());
  }

  int c_c4() {
    return Default.readBit(2, c_comp());
  }

  int c_c5() {
    return Default.readBit(1, c_comp());
  }

  int c_c6() {
    return Default.readBit(0, c_comp());
  }

  int c_d1() {
    return Default.readBit(2, c_dest());
  }

  int c_d2() {
    return Default.readBit(1, c_dest());
  }

  int c_d3() {
    return Default.readBit(0, c_dest());
  }

  int c_j1() {
    return Default.readBit(2, c_jump());
  }

  int c_j2() {
    return Default.readBit(1, c_jump());
  }

  int c_j3() {
    return Default.readBit(0, c_jump());
  }

  int [] all() {
    
    int [] allRegisters = {
      j3,
      j2,
      j1,
      d3,
      d2,
      d1,
      c6,
      c5,
      c4,
      c3,
      c2,
      c1,
      a,
      isC,
      isA,
      opcode,
      jump,
      dest,
      comp,
      address
    };
    
    return allRegisters;
  }
}
