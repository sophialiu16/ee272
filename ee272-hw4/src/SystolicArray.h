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
	Params paramsOut_;
        LoopIndices loopIndicesOut_;

	for (int oy1 = 0; oy1 < in_params.OY1; oy1++) {
          for (int ox1 = 0; ox1 < in_params.OX1; ox1++) {
            for (int oc1 = 0; oc1 < in_params.OC1; oc1++) {
              for (int ic1 = 0; ic1 < in_params.IC1; ic1++) {
                for (int fy = 0; fy < in_params.FY; fy++) {
                  for (int fx = 0; fx < in_params.FX; fx++) {
                    loopIndicesOut_.ic1_idx = ic1;
                    loopIndicesOut_.fx_idx = fx;
                    loopIndicesOut_.fy_idx = fy;
                    paramsOut_.OY1 = oy1;
                    paramsOut_.OX1 = ox1;
                    paramsOut_.OY0 = in_params.OY0;
                    paramsOut_.OX0 = in_params.OX0;
                    paramsOut_.OC1 = oc1;
                    paramsOut_.IC1 = ic1;
                    paramsOut_.FX = fx;
                    paramsOut_.FY = fy;
                    paramsOut_.STRIDE = in_params.STRIDE;
                  }
                }
              }
            }
          }
        }
        paramsOut.write(paramsOut_);
        loopIndicesOut.write(loopIndicesOut_);
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
