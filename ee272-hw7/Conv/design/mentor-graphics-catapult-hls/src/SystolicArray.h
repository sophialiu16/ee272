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
        Params params = paramsIn.read();
        

        #pragma hls_unroll no
        LABEL(xy_o) for (uint_16 p = 0; p < params.OX1 * params.OY1; ++p) { //loop over image tiles        
            #pragma hls_unroll no
            LABEL(OC2) for(uint_16 koo_idx = 0; koo_idx < params.OC1; ++koo_idx){ // loop over kernel tiles    
                #pragma hls_unroll no
                LABEL(co) for (uint_16 c_idx = 0; c_idx < params.IC1; ++c_idx) { // loop over channel tile
                    #pragma hls_unroll no
                    LABEL(winx) for (uint_16 wx_idx = 0; wx_idx < params.FX; ++wx_idx) { // loop over filter window x
                        #pragma hls_unroll no
                        LABEL(winy) for (uint_16 wy_idx = 0; wy_idx < params.FY; ++wy_idx) { // loop over filter window y
                                LoopIndices loopIndices = {
                                    c_idx, 
                                    wx_idx, 
                                    wy_idx
                                };
                                loopIndicesOut.write(loopIndices);
                                paramsOut.write(params);
                            
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
