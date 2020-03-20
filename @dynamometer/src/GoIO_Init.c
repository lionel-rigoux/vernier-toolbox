#include "mex.h"
#include "lib/libGoIO.h"

/* Initialise the GoIO suite  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int ret = GoIO_Init();
  if (ret != 0) {
    mexErrMsgTxt("GoIO.Init: Could not initialise the library.");
  }
  return;
}
