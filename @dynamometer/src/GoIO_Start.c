#include "mex.h"
#include "lib/libGoIO.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[1]);
  GOIO_SENSOR_HANDLE hDevice = *pHandle;


  // reset buffer
  int retValue = GoIO_Sensor_ClearIO(hDevice);
  if (retValue < 0) {
    mexErrMsgTxt("GoIO.Start: cannot clear the device buffer.");
  }
  // start
  int retValue2 = GoIO_Sensor_SendCmdAndGetResponse(hDevice, SKIP_CMD_ID_START_MEASUREMENTS, 0, 0, 0, 0, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue2 < 0) {
    mexErrMsgTxt("GoIO.Stop: cannot start the device.");
  }
  return;
}
