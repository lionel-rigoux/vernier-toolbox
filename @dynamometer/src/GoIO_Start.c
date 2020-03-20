#include "mex.h"
#include "lib/libGoIO.h"

/* Tell the device to start recording  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // Get the device handle
  /* ------------------------------------------------------------------------ */
  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[1]);
  GOIO_SENSOR_HANDLE hDevice = (GOIO_SENSOR_HANDLE) *pHandle;

  // Reset the buffer
  /* ------------------------------------------------------------------------ */
  int retValue = GoIO_Sensor_ClearIO(hDevice);
  if (retValue < 0) {
    mexErrMsgTxt("GoIO.Start: cannot clear the device buffer.");
  }

  // Initiate recording
  /* ------------------------------------------------------------------------ */
  int retValue2 = GoIO_Sensor_SendCmdAndGetResponse(hDevice, SKIP_CMD_ID_START_MEASUREMENTS, 0, 0, 0, 0, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue2 < 0) {
    mexErrMsgTxt("GoIO.Stop: cannot start the device.");
  }
  return;
}
