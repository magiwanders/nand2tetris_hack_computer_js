class CPU {
      
    ALU alu;
    PC PC;
    PCController PCc;

    int registerD, registerA, outM, writeM, addressM, pc, inA, loadA, loadD, x, y, outAlu, zr, ng, jump;
    
    CPU() {
      initialize();
    }
    
    void initialize() {
      // Components, chips "owned" by the cpu
      alu = new ALU();
      PC = new PC();
      PCc = new PCController();
      // Registers of the cpu
      registerD=0;
      registerA=0;
      // Outputs
      outM=0;
      writeM = 0;
      addressM=0;
      pc=0;
      // Internal "circuit lines"
      inA=0;
      loadA=0;
      loadD=0;
      x=0;
      y=0;
      outAlu=0;
      zr=0;
      ng=0;
      jump=0;
    }

  int [][] out(int inM, int instruction, int reset) {
    //println(instruction.toString(2).padStart(16, "0"))
    int [] oldState = {outM, writeM, addressM, pc, registerD};

    // Understand what is the instruction type
    Instruction inst = new Instruction(instruction);
    //println(inst)
    //int dummy=0;

    // addressM
    addressM = registerA;

    // outM
    x = registerD;
    y = inst.a==1 ? inM : addressM;

    // ALU
    int onlyC = inst.a==1 ? inst.comp-(1<<6) : inst.comp;
    int [] outALU = alu.out(x, y, onlyC);
    outAlu = outALU[0];
    zr = outALU[1];
    ng = outALU[2];
    outM =  inst.d3==1 ? outAlu : 0;

    // writeM
    writeM = inst.opcode==1 ? inst.d3 : 0;

    // PC
    int load = PCc.out(inst.opcode, zr, ng, inst.j1, inst.j2, inst.j3);
    int inc = load==1 ? 0 : 1;
    int [] outPC = PC.out(
      addressM,
      reset,
      load,
      inc
    );
    pc = outPC[1];

    // A register
    inA = inst.opcode==1 ? outAlu : instruction;
    loadA = (inst.d1==1) || (inst.opcode==0) ? 1 : 0;
    registerA = loadA==1 ? inA : registerA;

    // D register
    x = registerD;
    loadD = inst.opcode==1 ? inst.d2 : 0;
    registerD = loadD==1 ? outAlu : registerD;

    int [] newState = {outM, writeM, addressM, pc, registerD};

    // DEBUG
    if (Default.DEBUG) {
      println("---------CPU-IN----------");
      println("x = " + Integer.toBinaryString(x));
      println("y = " + Integer.toBinaryString(y));
      println("comp = " + Integer.toBinaryString(inst.comp));
      println("---------CPU-OUT----------");
      println("out = " + Integer.toBinaryString(outAlu));
      println("zr = " + Integer.toBinaryString(zr));
      println("ng = " + Integer.toBinaryString(ng));
      println("---------CPU-END----------");
    }

    int [][] completeState =  {oldState, newState}; 

    return completeState;
  }
}
