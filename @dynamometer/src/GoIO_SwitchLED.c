#include "mex.h"
#include "lib/libGoIO.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[1]);
  GOIO_SENSOR_HANDLE hDevice = *pHandle;


  char color;
  color = *mxGetChars(prhs[2]);
  mexPrintf("Change color to %c", color);


  GSkipSetLedStateParams ledParams;
  ledParams.brightness = kSkipMaxLedBrightness;

  switch(color) {
    case 'G':
      ledParams.color = kLEDGreen;
      break;
    case 'R':
      ledParams.color = kLEDRed;
      break;
   case 'O':
      ledParams.color = kLEDOrange;
      break;
  }
  int ret = GoIO_Sensor_SendCmdAndGetResponse(hDevice, SKIP_CMD_ID_SET_LED_STATE, &ledParams, 2, 0, 0, SKIP_TIMEOUT_MS_DEFAULT);


  /* store in output argument */
  /* ======================================================================== */
  plhs[0] = mxCreateDoubleScalar(ret);

  return;
}
