#include "mex.h"
#include "lib/libGoIO.h"

#define GOIO_MAX_SIZE_DEVICE_NAME 260
#include <stdint.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  int sensor_num = (int) mxGetScalar(prhs[0]);

  // get the identifier
  char deviceName[GOIO_MAX_SIZE_DEVICE_NAME];
  int retValue = GoIO_GetNthAvailableDeviceName(deviceName, GOIO_MAX_SIZE_DEVICE_NAME, VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID, sensor_num);

  if (retValue < 0) {
    plhs[0] = mxCreateDoubleScalar(-1);
    return;
  }

  // open the device and get the handle
  GOIO_SENSOR_HANDLE hDevice = GoIO_Sensor_Open(deviceName, VERNIER_DEFAULT_VENDOR_ID, SKIP_DEFAULT_PRODUCT_ID, 0);
  if (hDevice == NULL)
  {
    plhs[0] = mxCreateDoubleScalar(-2);
    return;
  }

  int frequency = 200;
  int retValue2 = GoIO_Sensor_SetMeasurementPeriod(hDevice, 1/frequency, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue2 < 0) {
    plhs[0] = mxCreateDoubleScalar(-3);
    return;
  }
  // store
  plhs[0] = mxCreateNumericMatrix(1,1,mxINT64_CLASS,mxREAL);
  mxSetData(plhs[0], &hDevice);

  plhs[1] = mxCreateNumericMatrix(1,1,mxINT64_CLASS,mxREAL);
  long long *ip = (long long *) mxGetData(plhs[1]);
  *ip = hDevice;

  return;
}
