#include "mex.h"
#include "lib/libGoIO.h"

/* Count how many devices are listed in the system  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // Count how many devices are available.
  /* ------------------------------------------------------------------------ */
  int GoIOnumSkips = GoIO_UpdateListOfAvailableDevices(VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID);
  // Return device count
  /* ------------------------------------------------------------------------ */
  plhs[0] = mxCreateDoubleScalar(GoIOnumSkips);
  return;
}
