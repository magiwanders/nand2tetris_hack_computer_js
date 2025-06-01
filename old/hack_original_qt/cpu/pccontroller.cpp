#include "pccontroller.h"
#include "utility/default.h"

int PCController::output(int opcode, int zr, int ng, int j1, int j2, int j3)
{
    bool jmp = (j1==1) & (j2==1) & (j3==1);
    bool jg = (j3==1) & (zr==0) & (ng==0);
    bool jl = (j1==1) & (zr==0) & (ng==1);
    bool jeq = (j2==1) & (zr==1) & (ng==0);
    bool j = jmp | jg | jl | jeq;
    int jj = j ? 1 : 0;
    return (opcode==1) ? jj : 0;
}
