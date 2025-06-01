class PCControllerTest{
 
  PCController pcc = new PCController();
                                                                                                        // outALU:  >0                       <0                       =0                       /impossible
  
  int [] opcode = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1};
  int [] zr     = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1};
  int [] ng     = {0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,   0, 0, 0, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1,  0, 0, 0, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1};
  int [] j1     = {0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,   0, 0, 0, 0, 1, 1, 1, 1,  0, 0, 0, 0, 1, 1, 1, 1,  0, 0, 0, 0, 1, 1, 1, 1,  0, 0, 0, 0, 1, 1, 1, 1};
  int [] j2     = {0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1,   0, 0, 1, 1, 0, 0, 1, 1,  0, 0, 1, 1, 0, 0, 1, 1,  0, 0, 1, 1, 0, 0, 1, 1,  0, 0, 1, 1, 0, 0, 1, 1};
  int [] j3     = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,   0, 1, 0, 1, 0, 1, 0, 1,  0, 1, 0, 1, 0, 1, 0, 1,  0, 1, 0, 1, 0, 1, 0, 1,  0, 1, 0, 1, 0, 1, 0, 1};
  int [] out    = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   0, 1, 0, 1, 0, 1, 0, 1,  0, 0, 0, 0, 1, 1, 1, 1,  0, 0, 1, 1, 0, 0, 1, 1,  0, 0, 0, 0, 0, 0, 0, 1};
  
  int nTests = out.length, failed=0;
  
  void test() {
    if (Default.VERBOSE) println("*** Functionality Test Start ***");
    
    for (int i=0; i<nTests; i++) {
      String outString = "PC Controller Test " + (i+1) + ": ";

      int currentTestResults = pcc.out(opcode[i], zr[i], ng[i], j1[i], j2[i], j3[i]);

      if (currentTestResults == out[i]) {
        outString += "Passed";
      } else {
        outString += "Failed";
        failed++;
      }

      // To test only one output
      // if (i==46) {
      //   println("opcode=" + opcode[i] + " zr=" + zr[i] + " ng=" + ng[i] + " j1=" + j1[i] + " j2=" + j2[i] + " j3=" + j3[i]);
      //   println("outOld: obtained " + currentTestResults +" <=> "+ out[i]+ " expected");
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
      int d = floor(random(0, 1) * nTests);
      int e = floor(random(0, 1) * nTests);
      int f = floor(random(0, 1) * nTests);
      long start = System.nanoTime();
      pcc.out(opcode[a], zr[b], ng[c], j1[d], j2[e], j3[f]);
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }

    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The PC Controller performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** PC CONTROLLER TEST END ******");
  }
  
}
