#include "mex.h"
#include "lib/libGoIO.h"
#include <stdint.h>

/* Close a device  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // Get the device handle
  /* ------------------------------------------------------------------------ */
  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[0]);
  GOIO_SENSOR_HANDLE hDevice = (GOIO_SENSOR_HANDLE) *pHandle;

  // Close the device
  /* ------------------------------------------------------------------------ */
  int retValue = GoIO_Sensor_Close(hDevice);
  if (retValue < 0) {
    mexErrMsgTxt("GoIO.Close: cannot close the device.");
  }

  return;
}
