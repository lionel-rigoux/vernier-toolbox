#include "mex.h"
#include "lib/libGoIO.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  /* Try to init  */
  /* ======================================================================== */
  int ret = GoIO_Uninit();

  /* store in output argument */
  /* ======================================================================== */
  plhs[0] = mxCreateDoubleScalar(ret);

  return;
}
