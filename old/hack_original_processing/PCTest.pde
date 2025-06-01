class PCTest{

  PC pc = new PC();
  
  int negVal = Default.complement2_16(-32123);
  
  int [] in = {
    0x0000,
    0x0000,
    negVal,
    negVal,
    negVal,
    negVal,
    0x3039,
    0x3039,
    0x3039,
    0x3039,
    0x3039,
    0x3039,
    0x0000,
    0x0000,
    0x56ce,
  };
  
  int [] out = {
    0x0000,
    0x0000,
    0x0001,
    0x0002,
    negVal,
    negVal+1,
    negVal+2,
    0x3039,
    0x0000,
    0x3039,
    0x0000,
    0x0001,
    0x0000,
    0x0000,
    0x0001,
    0x0000,    
  };
  
  int [] reset = {0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1};
  int [] load = {0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0};
  int [] inc = {0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0};

  int nTests = in.length, failed=0;
  
  void test() {
    if (Default.VERBOSE) println("*** Functionality Test Start ***");
    for (int i=0; i<nTests; i++) {
      String outString = "PC Test " + (i+1) + ": ";

      int [] currentTestResults = pc.out(in[i], reset[i], load[i], inc[i]);

      if (currentTestResults[0] == out[i] && currentTestResults[1] == out[i+1] ) {
        outString += "Passed";
      } else {
        outString += "Failed";
        failed++;
      }

      // To test only one output
      // if (i>=0) {
      //   println("in=" + Integer.toString(in[i]) + " reset=" + reset[i] + " load=" + load[i] + " inc=" + inc[i]);
      //   println("outOld: obtained " + currentTestResults[0] +" <=> "+ out[i]+ " expected");
      //   println("outNew: obtained " + currentTestResults[1] +" <=> "+ out[i+1]+ " expected");
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
      int a = floor(random(0,1) * nTests);
      int b = floor(random(0,1) * nTests);
      int c = floor(random(0,1) * nTests);
      int d = floor(random(0,1) * nTests);
      long start = System.nanoTime();
      pc.out(in[a], reset[b], load[c], inc[d]);
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }

    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The PC performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** PC TEST END ******");
  }
  
}
