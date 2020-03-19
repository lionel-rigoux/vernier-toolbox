#include "mex.h"
#include "lib/libGoIO.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  union {long long theinteger; void *thepointer;} ivp;
  long long *ip = (long long *) mxGetData(prhs[0]);
  ivp.theinteger = *ip;
  GOIO_SENSOR_HANDLE hDevice = ivp.thepointer;

  int ret = GoIO_Sensor_Close(hDevice);

  plhs[0] = mxCreateDoubleScalar(ret);

  return;
}
