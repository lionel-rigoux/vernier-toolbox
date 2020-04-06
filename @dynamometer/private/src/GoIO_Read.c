#include "mex.h"
#include "lib/libGoIO.h"
#include <string.h>

#define MAX_NUM_MEASUREMENTS 1500 // doc says 1200 is the max, but there could be more

/* Read and empty the internal buffer of the device, return values in N  */
/* ======================================================================== */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  // Get the device handle
  /* ------------------------------------------------------------------------ */
  gtype_int64 *pHandle = (gtype_int64 *) mxGetData(prhs[0]);
  GOIO_SENSOR_HANDLE hDevice = (GOIO_SENSOR_HANDLE) *pHandle;

  // Allocate memory for storing the values
  /* ------------------------------------------------------------------------ */
  gtype_int32 rawMeasurements[MAX_NUM_MEASUREMENTS];
  gtype_real64 volts[MAX_NUM_MEASUREMENTS];
  gtype_real64 calbMeasurements[MAX_NUM_MEASUREMENTS];

  // See how many measurements are to be read
  // numMeasurements could be set to MAX_NUM_MEASUREMENTS, but this could induce
  // loss of measurements at 200Hz
  /* ------------------------------------------------------------------------ */
  gtype_int32 numMeasurements = GoIO_Sensor_GetNumMeasurementsAvailable(hDevice);

  // Read raw measurements
  /* ------------------------------------------------------------------------ */
  GoIO_Sensor_ReadRawMeasurements(hDevice, rawMeasurements, numMeasurements);

  // Convert raw measurements to Newtons thanks to smart GoIO!Link smartness
  /* ------------------------------------------------------------------------ */
  for (int i = 0; i < numMeasurements; i++)
  {
    volts[i] = GoIO_Sensor_ConvertToVoltage(hDevice, rawMeasurements[i]);
    calbMeasurements[i] = GoIO_Sensor_CalibrateData(hDevice, volts[i]);
  }

  // Return measurements
  /* ------------------------------------------------------------------------ */
  plhs[0] = mxCreateDoubleMatrix(1, numMeasurements, mxREAL);
  memcpy(mxGetData(plhs[0]), &calbMeasurements, numMeasurements*sizeof(gtype_real64));

  return;
}
