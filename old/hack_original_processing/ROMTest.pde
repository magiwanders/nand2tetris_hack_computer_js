class ROMTest {
  
  ROM rom = new ROM();
  
  int failed=0;
  
  void test() {
    println("***** ROM TEST START ******");
    
    String [] programStrings = loadStrings("programs/Pong.hack");
    int nTests = programStrings.length;
    
    if(nTests==0) {
      println("No rom was present. Write rom in the box.");
      println("***** ROM TEST ABORTED *****");
      return;
    }
    
    int [] program = new int[nTests];
    
    for (int i=0; i<nTests; i++) {
      program[i]= Integer.parseInt(programStrings[i], 2);
      
    }
    
    rom.flash(program);
    
    if (Default.VERBOSE) println("*** Functionality Test Start ***");

    for (int i=0; i<nTests; i++) {
      String outString = "Rom Test " + (i+1) + ": ";

      int currentTestResults = rom.out(i);

      if (currentTestResults == program[i]) {
        outString += "Passed";
      } else {
        outString += "Failed";
        failed++;
      }

      //To test only one output
      // if (i>=16384) {
      //   println("address=" + i + " cell=" + program[i]);
      //   println("out: obtained " + currentTestResults +" <=> "+ program[i] + " expected");
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
      long start = System.nanoTime();
      rom.out(a);
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }

    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The Memory performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** ROM TEST END ******");
    
  }
  
}
