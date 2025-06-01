class CPUTest {
  
  CPU cpu = new CPU();
  
  int [] instruction = {
    0x3039,
    0xec10,
    0x5ba0,
    0xe1d0,
    0x03e8,
    0xe308,
    0x03e9,
    0xe398,
    0x03e8,
    0xf4d0,
    0x000e,
    0xe304,
    0x03e7,
    0xede0,
    0xe308,
    0x0015,
    0xe7c2,
    0x0002,
    0xe090,
    0x03e8,
    0xee90,
    0xe301,
    0xe302,
    0xe303,
    0xe304,
    0xe305,
    0xe306,
    0xe307,
    0xea90,
    0xe301,
    0xe302,
    0xe303,
    0xe304,
    0xe305,
    0xe306,
    0xe307,
    0xefd0,
    0xe301,
    0xe302,
    0xe303,
    0xe304,
    0xe305,
    0xe306,
    0xe307,
    0xe307,
    0x7fff  
  };
  
  int [] outM = {
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    11111,
    0x0,
    11110,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    -1,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
  };
  
  int [] addressM = {
    0,
    0,
    12345,
    12345,
    23456,
    23456,
    1000,
    1000,
    1001,
    1001,
    1000,
    1000,
    14,
    14,
    999,
    1000,
    1000,
    21,
    21,
    2,
    2,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    32767
  };
  
  int minusOne = Default.complement2_16(-1);
  
  int [] registerD = {
    0,
    0,
    12345,
    12345,
    11111,
    11111,
    11111,
    11111,
    11110,
    11110,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    1,
    1,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    minusOne,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1, 
    1, 
    1, 
    1, 
    1, 
    1, 
    1, 
    1, 
    1, 
    1
  };
  
  int [] writeM = {0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int [] reset = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0};
  
  int [] inM = {
    0, 
    0, 
    0, 
    0, 
    0, 
    0, 
    0, 
    0, 
    0,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111,
    11111
  };
        
  int [] pc = {
    0, 
    1, 
    2, 
    3, 
    4, 
    5, 
    6, 
    7, 
    8, 
    9, 
    10, 
    11, 
    14, 
    15, 
    16, 
    17, 
    18, 
    21, 
    22, 
    23, 
    24, 
    25, 
    26, 
    27, 
    28, 
    1000, 
    1000, 
    1000, 
    1000, 
    1001, 
    1002, 
    1000, 
    1000, 
    1001, 
    1002, 
    1000, 
    1000, 
    1001, 
    1000, 
    1001, 
    1000, 
    1001, 
    1000, 
    1001, 
    1000, 
    0, 
    1
  };
  
  int nTests = instruction.length, failed = 0;
  
  void test() {
    if (Default.VERBOSE) println("*** Functionality Test Start ***");
    for (int i=0; i<nTests; i++) {
      String outString = "CPU Test " + (i+1) + ": ";

      int [][] currentTestResults = cpu.out(inM[i], instruction[i], reset[i]);

      if(outM[i]==0x0 || outM[i+1]==0x0) {
        if (
          //currentTestResults[0][0] == outM[i] && currentTestResults[1][0] == outM[i+1] &&
          currentTestResults[0][1] == writeM[i] && currentTestResults[1][1] == writeM[i+1] &&
          currentTestResults[0][2] == addressM[i] && currentTestResults[1][2] == addressM[i+1] &&
          currentTestResults[0][3] == pc[i] && currentTestResults[1][3] == pc[i+1] &&
          currentTestResults[0][4] == registerD[i] && currentTestResults[1][4] == registerD[i+1]
        ) {
          outString += "Passed";
        } else {
          outString += "Failed";
          failed++;
        }
      } else {
        if (
          currentTestResults[0][0] == outM[i] && currentTestResults[1][0] == outM[i+1] &&
          currentTestResults[0][1] == writeM[i] && currentTestResults[1][1] == writeM[i+1] &&
          currentTestResults[0][2] == addressM[i] && currentTestResults[1][2] == addressM[i+1] &&
          currentTestResults[0][3] == pc[i] && currentTestResults[1][3] == pc[i+1] &&
          currentTestResults[0][4] == registerD[i] && currentTestResults[1][4] == registerD[i+1]
        ) {
          outString += "Passed";
        } else {
          outString += "Failed";
          failed++;
        }
      }

       //To test only one output
       if (i>=0 && i<0) {
      
         if (currentTestResults[0][0] == outM[i]) {println("ok");} else { if(outM[i]==0x0) {println("ok");} else {println("fail");}}
         if (currentTestResults[1][0] == outM[i+1]) {println("ok");} else { if(outM[i+1]==0x0) { println("ok");} else { println("fail");}}
         if (currentTestResults[0][1] == writeM[i]) println("ok"); else println("fail");
         if (currentTestResults[1][1] == writeM[i+1]) println("ok"); else println("fail");
         if (currentTestResults[0][2] == addressM[i]) println("ok"); else println("fail");
         if (currentTestResults[1][2] == addressM[i+1]) println("ok"); else println("fail");
         if (currentTestResults[0][3] == pc[i]) println("ok"); else println("fail");
         if (currentTestResults[1][3] == pc[i+1]) println("ok"); else println("fail");
         if (currentTestResults[0][4] == registerD[i]) println("ok"); else println("fail");
         if (currentTestResults[1][4] == registerD[i+1]) println("ok"); else println("fail");
      
         println("inM=" + Integer.toBinaryString(inM[i]) + " instruction=" + Integer.toBinaryString(instruction[i]) + " reset=" + reset[i]);
         println("outM:          obtained " + currentTestResults[0][0] +" <=> "+ outM[0] + " expected");
         println("new outM:      obtained " + currentTestResults[1][0] +" <=> "+ outM[i+1]+ " expected");
         println("writeM:        obtained " + currentTestResults[0][1] +" <=> "+ writeM[i] + " expected");
         println("new writeM:    obtained " + currentTestResults[1][1] +" <=> "+ writeM[i+1]+ " expected");
         println("addressM:      obtained " + currentTestResults[0][2] +" <=> "+ addressM[i] + " expected");
         println("new addressM:  obtained " + currentTestResults[1][2] +" <=> "+ addressM[i+1]+ " expected");
         println("pc:            obtained " + currentTestResults[0][3] +" <=> "+ pc[i] + " expected");
         println("new pc:        obtained " + currentTestResults[1][3] +" <=> "+ pc[i+1]+ " expected");
         println("registerD:     obtained " + currentTestResults[0][4] +" <=> "+ registerD[i] + " expected");
         println("new registerD: obtained " + currentTestResults[1][4] +" <=> "+ registerD[i+1]+ " expected");
       }

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
      cpu.out(inM[a], instruction[b], reset[c]);
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }

    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The CPU performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** CPU TEST END ******");
  }
}
