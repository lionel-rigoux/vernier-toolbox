#include "mex.h"
#include "lib/libGoIO.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  union {long long theinteger; void *thepointer;} ivp;
  long long *ip = (long long *) mxGetData(prhs[0]);
  ivp.theinteger = *ip;
  GOIO_SENSOR_HANDLE hDevice = ivp.thepointer;

  char color;
  color = *mxGetChars(prhs[0]);


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
