class InstructionTest {

      // FUNCTIONALITY TEST
  int [] instruction = {
    0x0000,
    0x0001,
    0x0006,
    0x7fff,
    0xf000,
    0xf480,
    0xeb49,
    0xefd2,
    0xe01b,
    0xf224,
    0xeead,
    0xe976,
    0xe1ff,
    0xf5e5,
    0xe263,
    0xffff,
    0xaa27,
    0xd459,
    0x92bf,
  };
  
  int [] isA = {1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int [] isC = {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0};
  int [] opcode = {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
  int [] address = {0, 1, 6, 32767, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
  
  int [] comp = {
    0x0000,
    0x0000,
    0x0000,
    0x007f,
    0x0040,
    0x0052,
    0x002d,
    0x003f,
    0x0000,
    0x0048,
    0x003a,
    0x0025,
    0x0007,
    0x0057,
    0x0009,
    0x007f,
    0x0028,
    0x0051,
    0x004a,
  };
    
  int [] a = {0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1};
  int [] c1 = {0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0};
  int [] c2 = {0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0};
  int [] c3 = {0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1};
  int [] c4 = {0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0};
  int [] c5 = {0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1};
  int [] c6 = {0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0};
  
  int [] dest = {
    0x0000,
    0x0000,
    0x0000,
    0x0007,
    0x0000,
    0x0000,
    0x0001,
    0x0002,
    0x0003,
    0x0004,
    0x0005,
    0x0006,
    0x0007,
    0x0004,
    0x0004,
    0x0007,
    0x0004,
    0x0003,
    0x0007,
  };
  
  int [] d1 = {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1};
  int [] d2 = {0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1};
  int [] d3 = {0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1};
    
  int [] jump = {
    0x0000,
    0x0001,
    0x0006,
    0x0007,
    0x0000,
    0x0000,
    0x0001,
    0x0002,
    0x0003,
    0x0004,
    0x0005,
    0x0006,
    0x0007,
    0x0005,
    0x0003,
    0x0007,
    0x0007,
    0x0001,
    0x0007,
  };
    
  int [] j1 = {0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1};
  int [] j2 = {0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1};
  int [] j3 = {0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1};

  int nTests = instruction.length, failed = 0;

  void test() {
    if (Default.VERBOSE) println("*** Functionality Test Start ***");
    for (int i=0; i<nTests; i++) {
      String outString = "Instructions Test " + (i+1) + ": ";

      Instruction inst = new Instruction(instruction[i]);
      //println(inst)
      int [] currentTestResults = inst.all();

      if(i>15) {
        if (inst.error=="error") {outString += "Passed";} else {outString += "Failed";}
      } else {
        if (currentTestResults[0] == j3[i] &&
            currentTestResults[1] == j2[i] &&
            currentTestResults[2] == j1[i] &&
            currentTestResults[3] == d3[i] &&
            currentTestResults[4] == d2[i] &&
            currentTestResults[5] == d1[i] &&
            currentTestResults[6] == c6[i] &&
            currentTestResults[7] == c5[i] &&
            currentTestResults[8] == c4[i] &&
            currentTestResults[9] == c3[i] &&
            currentTestResults[10] == c2[i] &&
            currentTestResults[11] == c1[i] &&
            currentTestResults[12] == a[i] &&
            currentTestResults[13] == isC[i] &&
            currentTestResults[14] == isA[i] &&
            currentTestResults[15] == opcode[i] &&
            currentTestResults[16] == jump[i] &&
            currentTestResults[17] == dest[i] &&
            currentTestResults[18] == comp[i] &&
            currentTestResults[19] == address[i]
          ) {
          outString += "Passed";
        } else {
          outString += "Failed";
          failed++;
        }
      }



      // To test only one output
      // if (i>15) {
      //
      //   currentTestResults[0] == j3[i] ? println("ok") : println("fail");
      //   currentTestResults[1] == j2[i] ? println("ok") : println("fail");
      //   currentTestResults[2] == j1[i] ? println("ok") : println("fail");
      //   currentTestResults[3] == d3[i] ? println("ok") : println("fail");
      //   currentTestResults[4] == d2[i] ? println("ok") : println("fail");
      //   currentTestResults[5] == d1[i] ? println("ok") : println("fail");
      //   currentTestResults[6] == c6[i] ? println("ok") : println("fail");
      //   currentTestResults[7] == c5[i] ? println("ok") : println("fail");
      //   currentTestResults[8] == c4[i] ? println("ok") : println("fail");
      //   currentTestResults[9] == c3[i] ? println("ok") : println("fail");
      //   currentTestResults[10] == c2[i] ? println("ok") : println("fail");
      //   currentTestResults[11] == c1[i] ? println("ok") : println("fail");
      //   currentTestResults[12] == a[i] ? println("ok") : println("fail");
      //   currentTestResults[13] == isC[i] ? println("ok") : println("fail");
      //   currentTestResults[14] == isA[i] ? println("ok") : println("fail");
      //   currentTestResults[15] == opcode[i] ? println("ok") : println("fail");
      //   currentTestResults[16] == jump[i] ? println("ok") : println("fail");
      //   currentTestResults[17] == dest[i] ? println("ok") : println("fail");
      //   currentTestResults[18] == comp[i] ? println("ok") : println("fail");
      //   currentTestResults[19] == address[i] ? println("ok") : println("fail");
      //
      //   println("instruction=" + instruction[i].toString(2).padStart(16, "0"));
      //   println("j3     : obtained " + currentTestResults[0] +" <=> "+ j3[i] + " expected");
      //   println("j2     : obtained " + currentTestResults[1] +" <=> "+ j2[i] + " expected");
      //   println("j1     : obtained " + currentTestResults[2] +" <=> "+ j1[i] + " expected");
      //   println("d3     : obtained " + currentTestResults[3] +" <=> "+ d3[i] + " expected");
      //   println("d2     : obtained " + currentTestResults[4] +" <=> "+ d2[i] + " expected");
      //   println("d1     : obtained " + currentTestResults[5] +" <=> "+ d1[i] + " expected");
      //   println("c6     : obtained " + currentTestResults[6] +" <=> "+ c6[i] + " expected");
      //   println("c5     : obtained " + currentTestResults[7] +" <=> "+ c5[i] + " expected");
      //   println("c4     : obtained " + currentTestResults[8] +" <=> "+ c4[i] + " expected");
      //   println("c3     : obtained " + currentTestResults[9] +" <=> "+ c3[i] + " expected");
      //   println("c2     : obtained " + currentTestResults[10] +" <=> "+ c2[i] + " expected");
      //   println("c1     : obtained " + currentTestResults[11] +" <=> "+ c1[i] + " expected");
      //   println("a      : obtained " + currentTestResults[12] +" <=> "+ a[i] + " expected");
      //   println("isC    : obtained " + currentTestResults[13] +" <=> "+ isC[i] + " expected");
      //   println("isA    : obtained " + currentTestResults[14] +" <=> "+ isA[i] + " expected");
      //   println("opcode : obtained " + currentTestResults[15] +" <=> "+ opcode[i] + " expected");
      //   println("jump   : obtained " + currentTestResults[16] +" <=> "+ jump[i] + " expected");
      //   println("dest   : obtained " + currentTestResults[17] +" <=> "+ dest[i] + " expected");
      //   println("comp   : obtained " + currentTestResults[18] +" <=> "+ comp[i] + " expected");
      //   println("address: obtained " + currentTestResults[19] +" <=> "+ address[i] + " expected");
      // }

      if (Default.VERBOSE) println(outString);
    }

    println("Completed " + nTests + " functionality tests of which " + failed + " failed.");
    if (Default.VERBOSE) println("*** Functionality Test End ***");

    // SPEED TEST
    if (Default.VERBOSE) println("*** Speed Test Start ***");

    long timeElapsed=0;


    for(int j=0; j<Default.PERFORMANCE_TEST_REPEAT;j++) {
      if(j%100000==0) if (Default.VERBOSE) println("[Testing performance...]");
      int a = floor(random(0, 1) * nTests);
      long start = System.nanoTime();
      Instruction inst = new Instruction(instruction[a]);
      inst.all();
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }

    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The Instrucions performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** INSTRUCTIONS TEST END ******");
  }

}
