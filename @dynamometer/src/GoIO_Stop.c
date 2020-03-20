#include "mex.h"
#include "lib/libGoIO.h"

/* Tell the device to stop recording  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // Get the device handle
  /* ------------------------------------------------------------------------ */
  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[1]);
  GOIO_SENSOR_HANDLE hDevice = (GOIO_SENSOR_HANDLE) *pHandle;

  // Tell the device to stop recording
  /* ------------------------------------------------------------------------ */
    int retValue = GoIO_Sensor_SendCmdAndGetResponse(hDevice, SKIP_CMD_ID_STOP_MEASUREMENTS, 0, 0, 0, 0, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue < 0) {
    mexErrMsgTxt("GoIO.Stop: failed to stop the device.");
  }
  return;
}
