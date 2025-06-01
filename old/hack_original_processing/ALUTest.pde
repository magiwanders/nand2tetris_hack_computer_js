class ALUTest {

  ALU alu = new ALU();
  
  int [] x = {
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0000,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011,
    0x0011
  };
  
  int [] y = {
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0xffff,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003,
    0x0003  
  };
  
  int [] comp = {
    0x002a,
    0x003f,
    0x003a,
    0x000c,
    0x0030,
    0x000d,
    0x0031,
    0x000f,
    0x0033,
    0x001f,
    0x0037,
    0x000e,
    0x0032,
    0x0002,
    0x0013,
    0x0007,
    0x0000,
    0x0015,
    0x002a,
    0x003f,
    0x003a,
    0x000c,
    0x0030,
    0x000d,
    0x0031,
    0x000f,
    0x0033,
    0x001f,
    0x0037,
    0x000e,
    0x0032,
    0x0002,
    0x0013,
    0x0007,
    0x0000,
    0x0015  
  };
  
  int [] out = {
    0x0000,
    0x0001,
    0xffff,
    0x0000,
    0xffff,
    0xffff,
    0x0000,
    0x0000,
    0x0001,
    0x0001,
    0x0000,
    0xffff,
    0xfffe,
    0xffff,
    0x0001,
    0xffff,
    0x0000,
    0xffff,
    0x0000,
    0x0001,
    0xffff,
    0x0011,
    0x0003,
    0xffee,
    0xfffc,
    0xffef,
    0xfffd,
    0x0012,
    0x0004,
    0x0010,
    0x0002,
    0x0014,
    0x000e,
    0xfff2,
    0x0001,
    0x0013  
  };
  
  int [] zr = {1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int [] ng = {0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0};
  
  int nTests = x.length, failed=0;
  
  void test() {
    println("***** ALU TEST START ******");

    if (Default.VERBOSE) println("*** Functionality Test Start ***");

    for (int i=0; i<nTests; i++) {
      String outString = "ALU Test " + (i+1) + ": ";

      int [] currentTestResults = alu.out(x[i], y[i], comp[i]);

      if (currentTestResults[0] == out[i] && currentTestResults[1] == zr[i] && currentTestResults[2] == ng[i] ) {
        outString += "Passed";
      } else {
        outString += "Failed";
        failed++;
      }

      // To test only one output
      // if (i==35) {
      //   println("x=" + Integer.toBinaryString(x[i]) + " y=" + Integer.toBinaryString(y[i]) + " comp=" + Integer.toBinaryString(comp[i]));
      //   println("out: obtained " + currentTestResults[0] +" <=> "+ out[i] +" expected");
      //   println("zr : obtained " + currentTestResults[1] +" <=> "+ zr[i] +" expected");
      //   println("ng : obtained " + currentTestResults[2] +" <=> "+ ng[i] +" expected");
      // }

      if (Default.VERBOSE) println(outString);
    }
    
    println("Completed " + nTests + " functionality tests of which " + failed + " failed.");
    if (Default.VERBOSE) println("*** Functionality Test End ***");

    // SPEED TEST
    if (Default.VERBOSE) println("*** Speed Test Start ***");

    long timeElapsed=0;


    for(int j=0; j<Default.PERFORMANCE_TEST_REPEAT;j++) {
      if(j%100000==0) {if (Default.VERBOSE) println("[Testing performance...]");}
      int a = floor(random(0, 1) * nTests);
      int b = floor(random(0, 1) * nTests);
      int c = floor(random(0, 1) * nTests);
      long start = System.nanoTime();
      alu.out(x[a], y[b], comp[c]);
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }

    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The ALU performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** ALU TEST END ******");
  }

}
