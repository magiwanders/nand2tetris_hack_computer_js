class PC {

  int pc = 0;

  int [] out(int in, int reset, int load, int inc) {
    int oldOut = pc;

    if (reset==1) {
      pc=0;
      // println("[PC] Reset");
    } else if (load==1) {
      pc=in;
      // println("[PC] Load");
    } else if (inc==1) {
      pc++;
      // println("[PC] Increment");
    }

    int [] out = {oldOut, pc};

    return out;
  }

}
