#include "mex.h"
#include "lib/libGoIO.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  /* Get library version  */
  /* ======================================================================== */
  gtype_uint16 pMajorVersion;
	gtype_uint16 pMinorVersion;
  int ret = GoIO_GetDLLVersion(&pMajorVersion, &pMinorVersion);

  /* store in output argument */
  /* ======================================================================== */
  plhs[0] = mxCreateDoubleScalar(ret);
  plhs[1] = mxCreateDoubleScalar(pMajorVersion);
  plhs[2] = mxCreateDoubleScalar(pMinorVersion);

  return;
}
