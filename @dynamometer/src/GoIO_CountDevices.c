#include "mex.h"
#include "lib/libGoIO.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  /* Get library version  */
  /* ======================================================================== */
  int GoIOnumSkips = GoIO_UpdateListOfAvailableDevices(VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID);

  /* store in output argument */
  /* ======================================================================== */
  plhs[0] = mxCreateDoubleScalar(GoIOnumSkips);

  return;
}
