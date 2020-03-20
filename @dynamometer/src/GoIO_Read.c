#include "mex.h"
#include "lib/libGoIO.h"

#define MAX_NUM_MEASUREMENTS 2000

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[1]);
  GOIO_SENSOR_HANDLE hDevice = *pHandle;


  /* Try to init  */
  /* ======================================================================== */

  gtype_int32 rawMeasurements[MAX_NUM_MEASUREMENTS];
  gtype_real64 volts[MAX_NUM_MEASUREMENTS];
  double calbMeasurements[MAX_NUM_MEASUREMENTS];
  gtype_int32 numMeasurements, i;

  numMeasurements = GoIO_Sensor_ReadRawMeasurements(hDevice, rawMeasurements, MAX_NUM_MEASUREMENTS);
  mexPrintf("%d measurements received after about 1 second.\n", numMeasurements);
  for (i = 0; i < numMeasurements; i++)
  {
    volts[i] = GoIO_Sensor_ConvertToVoltage(hDevice, rawMeasurements[i]);
    calbMeasurements[i] = (double) GoIO_Sensor_CalibrateData(hDevice, volts[i]);
  }


  plhs[0] = mxCreateDoubleMatrix(1, numMeasurements, mxREAL);
  //memcpy(mxGetPr(plhs[0]), calbMeasurements, numMeasurements * sizeof(double));
  memcpy( mxGetData(plhs[0]), &calbMeasurements, numMeasurements * sizeof(double) );

  return;
}
