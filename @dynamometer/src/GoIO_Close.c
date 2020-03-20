#include "mex.h"
#include "lib/libGoIO.h"
#include <stdint.h>

/* Close a device  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  //union {gtype_int64 theinteger; void *thepointer;} ivp;
  //gtype_int64 *ip = (gtype_int64 *) mxGetData(prhs[1]);
  //ivp.theinteger = *ip;
  //GOIO_SENSOR_HANDLE hDevice = ivp.thepointer;

  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[1]);
  GOIO_SENSOR_HANDLE hDevice = (GOIO_SENSOR_HANDLE) *pHandle;


  int ret = GoIO_Sensor_Close(hDevice);

  plhs[0] = mxCreateDoubleScalar(ret);

  return;
}
