#include "mex.h"
#include "lib/libGoIO.h"

#define GOIO_MAX_SIZE_DEVICE_NAME 260
#include <stdint.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // get which device needs to be open
  int sensorNum = (int) mxGetScalar(prhs[0]);
  if (sensorNum < 0) {
    mexErrMsgTxt("GoIO.Open: sensor number must be a positive integer.");
  }

  // Count how many devices are available.
  // Note that GoIO_GetNthAvailableDeviceName will fail if this is not called first
  /* ------------------------------------------------------------------------ */
  int GoIOnumSkips = GoIO_UpdateListOfAvailableDevices(VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID);
  if (sensorNum >= GoIOnumSkips) {
    mexErrMsgTxt("GoIO.Open: sensor number too large, not enough devices available.");
  }

  // Get the device identifier in the syste,
  /* ------------------------------------------------------------------------ */
  char deviceName[GOIO_MAX_SIZE_DEVICE_NAME];
  int retValue = GoIO_GetNthAvailableDeviceName(deviceName, GOIO_MAX_SIZE_DEVICE_NAME, VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID, sensorNum);
  if (retValue < 0) {
    mexErrMsgTxt("GoIO.Open: cannot find device identifier in the system.");
  }

  // Open the device and get the device handle
  /* ------------------------------------------------------------------------ */
  GOIO_SENSOR_HANDLE hDevice = GoIO_Sensor_Open(deviceName, VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID, 0);
  if (hDevice == NULL) {
    mexErrMsgTxt("GoIO.Open: cannot find device identifier in the system.");
  }

  // Set recording frequency to 200Hz
  /* ------------------------------------------------------------------------ */
  gtype_real64 period = 1/200;
  int retValue2 = GoIO_Sensor_SetMeasurementPeriod(hDevice, period, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue2 < 0) {
    mexErrMsgTxt("GoIO.Open: cannot set device recording frequency.");
  }

  // Return device handle
  // This is a a void* that we recast as int64 so it can be stored in Matlab
  /* ------------------------------------------------------------------------ */
  plhs[0] = mxCreateNumericMatrix(1,1,mxINT64_CLASS,mxREAL);
  gtype_int64 *ip = (gtype_int64 *) mxGetData(plhs[0]);
  *ip = (gtype_int64) hDevice;

  return;
}
