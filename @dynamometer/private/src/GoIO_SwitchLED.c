#include "mex.h"
#include "lib/libGoIO.h"

/* Change the LED color on the device ('R': red, 'O': orange, 'G': green)*/
/* Tell the device to start recording  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // Get the device handle
  /* ------------------------------------------------------------------------ */
  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[0]);
  GOIO_SENSOR_HANDLE hDevice = (GOIO_SENSOR_HANDLE) *pHandle;

  // Get the required color
  /* ------------------------------------------------------------------------ */
  char color;
  color = *mxGetChars(prhs[1]);

  // Create option structure to send the instruction to the device
  /* ------------------------------------------------------------------------ */
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

  // Tell the device to change the LED settings
  /* ------------------------------------------------------------------------ */
  int retValue = GoIO_Sensor_SendCmdAndGetResponse(hDevice, SKIP_CMD_ID_SET_LED_STATE, &ledParams, 2, 0, 0, SKIP_TIMEOUT_MS_DEFAULT);
  if (retValue < 0) {
    mexErrMsgTxt("GoIO.SwitchLED: cannot change the LED settings.");
  }

  return;
}
