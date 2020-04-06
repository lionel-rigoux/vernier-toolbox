#include "mex.h"
#include "lib/libGoIO.h"

/* Unnitialise the GoIO suite  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int ret = GoIO_Uninit();
  if (ret < 0) {
    mexErrMsgTxt("GoIO.Uninit: Could not uninitialise the library.");
  }
  return;
}
