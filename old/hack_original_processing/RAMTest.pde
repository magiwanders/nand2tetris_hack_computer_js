class RAMTest {
  
    RAM ram = new RAM();
  
    int [] in = {
      0xffff, 
      0xffff, 
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x08ae,
      0x08ae,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x270f,
      0x04d2,
      0x04d2,
      0x04d2,
      0x04d2,
      0x0929,
      0x0929,
      0x0929,
      0x0929,
      0x0929,
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
      0xffff
    };
  
    int [] address = {
      0x0000,
      0x0000,
      0x0000,
      0x0000,
      0x2000,
      0x4000,
      0x2000,
      0x2000,
      0x2000,
      0x2000,
      0x0000,
      0x4000,
      0x0001,
      0x0002,
      0x0004,
      0x0008,
      0x0010,
      0x0020,
      0x0040,
      0x0080,
      0x0100,
      0x0200,
      0x0400,
      0x0800,
      0x1000,
      0x2000,
      0x1234,
      0x1234,
      0x2234,
      0x6234,
      0x2345,
      0x2345,
      0x0345,
      0x4345,
      0x6000,
      0x4fcf,
      0x504f,
      0x0fcf,
      0x2fcf,
      0x4fce,
      0x4fcd,
      0x4fcb,
      0x4fc7,
      0x4fdf,
      0x4fef,
      0x4f8f,
      0x4f4f,
      0x4ecf,
      0x4dcf,
      0x4bcf,
      0x47cf,
      0x5fcf,
      0x6000
    };
  
    int [] load = {1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  
    int [] out = {
      0x0000,
      0xffff,
      0xffff,
      0xffff,
      0x0000,
      0x0000,
      0x0000,
      0x08ae,
      0x08ae,
      0x08ae,
      0xffff,
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
      0x08ae,
      0x0000,
      0x04d2,
      0x0000,
      0x0000,
      0x0000,
      0x0929,
      0x0000,
      0x0000,
      0x004b,
      0xffff,
      0xffff,
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
       0x0059,
   };
  
   int nTests = in.length, failed = 0;
  
   void test() {
     if(Default.VERBOSE) println("*** Functionality Test Start ***");
     
     ram.write_word(0x4fcf, 0xffff);
     ram.write_word(0x504f, 0xffff);
     
     for (int i=0; i<nTests; i++) {
       String outString = "Memory Test " + (i+1) + ": ";

       if(i==34) ram.write_word(0x6000, 75);
       if(i==52) ram.write_word(0x6000, 89);

       int currentTestResults = ram.out(in[i], load[i], address[i]);

       if (currentTestResults == out[i]) {
         outString += "Passed";
       } else {
         outString += "Failed";
         failed++;
       }

      //To test only one output
      // if (i==35) {
      //   println("in=" + in[i] + " load=" + load[i].toString(2) + " address=" + address[i].toString(2));
      //   println("out: obtained " + currentTestResults +" <=> "+ out[i] + " expected");
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
      ram.out(in[a], load[b], address[c]);
      long end = System.nanoTime();
      timeElapsed+=(end-start);
    }
    
    long nsPerOperation = timeElapsed/Default.PERFORMANCE_TEST_REPEAT;

    println("The Memory performance is " + nsPerOperation + "ns/operation." );
    if (Default.VERBOSE) println("*** Speed Test End ***");

    println("***** ALU TEST END ******");
    
    }
}
