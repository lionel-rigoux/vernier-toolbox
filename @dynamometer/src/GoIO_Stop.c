#include "mex.h"
#include "lib/libGoIO.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  union {long long theinteger; void *thepointer;} ivp;
  long long *ip = (long long *) mxGetData(prhs[0]);
  ivp.theinteger = *ip;
  GOIO_SENSOR_HANDLE hDevice = ivp.thepointer;

  /* Try to init  */
  /* ======================================================================== */

  int retValue = GoIO_Sensor_SendCmdAndGetResponse(hDevice, SKIP_CMD_ID_STOP_MEASUREMENTS, 0, 0, 0, 0, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue < 0) {
    plhs[0] = mxCreateDoubleScalar(-1);
    return;
  }

  plhs[0] = mxCreateDoubleScalar(0);
  return;
}
