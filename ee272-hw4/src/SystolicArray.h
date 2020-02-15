#ifndef SYSTOLIC_ARRAY_H
#define SYSTOLIC_ARRAY_H

#include "ProcessingElement.h"
#include "conv.h"
#include "Fifo.h"
#include "SystolicArrayCore.h"

// Include mc_scverify.h for CCS_* macros
#include <mc_scverify.h>

class SystolicArrayLooper
{
public:
    SystolicArrayLooper() {}

#pragma hls_design interface
void run(ac_channel<Params> &paramsIn,
         ac_channel<Params> &paramsOut,
         ac_channel<LoopIndices> &loopIndicesOut)
    {
        // -------------------------------
        // Your code starts here
        // Generate the loop indices here for the systolic array.
        // Write the loop indices as well as the params out to channels.
        // -------------------------------

	Params in_params = paramsIn.read();

	for (oy1 = 0; oy1 < in_params.OY1; oy1++) {
          for (ox1 = 0; ox1 < in_params.OX1; ox1++) {
            for (oc1 = 0; oc1 < in_params.OC1; oc1++) {
              for (ic1 = 0; ic1 < in_params.IC1; ic1++) {
                for (fy = 0; fy < in_params.FY; fy++) {
                  for (fx = 0; fx < in_params.FX; fx++) {
                    loopIndicesOut.ic1_idx.write(ic1);
                    loopIndicesOut.fx_idx.write(fx);
                    loopIndicesOut.fy_idx.write(fy);
                    paramsOut.OY1.write(oy1);
                    paramsOut.OX1.write(ox1);
                    paramsOut.OY0.write(oy0);
                    paramsOut.OX0.write(ox0);
                    paramsOut.OC1.write(oc1);
                    paramsOut.IC1.write(ic1);
                    paramsOut.FX.write(fx);
                    paramsOut.FY.write(fy);
                    paramsOut.STRIDE.write(in_params.STRIDE);
                  }
                }
              }
            }
          }
        }
        // -------------------------------
        // Your code ends here
        // -------------------------------
    }
};

template <typename IDTYPE, typename WDTYPE, typename ODTYPE, int OC0, int IC0>
class SystolicArrayWrapper
{
public:
    SystolicArrayWrapper(){}
    
#pragma hls_design interface
#pragma hls_pipeline_init_interval 1
    void run(ac_channel<PackedInt<INPUT_PRECISION, IC0> > &input, 
             ac_channel<PackedInt<WEIGHT_PRECISION, OC0> > &weight, 
             ac_channel<PackedInt<OUTPUT_PRECISION, OC0> > &output,
             ac_channel<Params> &paramsIn)
    {
        systolicArrayLooper.run(paramsIn, paramsChannel, loopIndicesChannel);
        systolicArrayCore.run(input, weight, output, paramsChannel, loopIndicesChannel);
    }
private:
    SystolicArrayCore<IDTYPE, WDTYPE, ODTYPE, OC0, IC0> systolicArrayCore;
    SystolicArrayLooper systolicArrayLooper;
    ac_channel<Params> paramsChannel;
    ac_channel<LoopIndices> loopIndicesChannel;
};

#endif
