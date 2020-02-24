#ifndef SYSTOLIC_ARRAY_CORE_H
#define SYSTOLIC_ARRAY_CORE_H

#include <boost/preprocessor/repetition/repeat.hpp>
#include <boost/preprocessor/punctuation/comma_if.hpp>
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/comparison/not_equal.hpp>
#include <boost/preprocessor/repetition/for.hpp>
#include <boost/preprocessor/tuple/elem.hpp>
#include <boost/preprocessor/tuple/size.hpp>
#include <boost/preprocessor/control/if.hpp>
#include <boost/preprocessor/punctuation/comma.hpp>
#include <boost/preprocessor/arithmetic/dec.hpp>

#include "ProcessingElement.h"
#include "Fifo.h"


struct LoopIndices{
    uint_16 ic1_idx;
    uint_16 fx_idx;
    uint_16 fy_idx;
};



template <typename IDTYPE, typename WDTYPE, typename ODTYPE, int OC0, int IC0>
class SystolicArrayCore
{
public:
    SystolicArrayCore() {}

#pragma hls_design interface
//#pragma hls_pipeline_init_interval 1
    void run(
        ac_channel<PackedInt<INPUT_PRECISION, IC0> > &input, 
        ac_channel<PackedInt<WEIGHT_PRECISION, OC0> > &weight, 
        ac_channel<PackedInt<OUTPUT_PRECISION, OC0> > &output,
        ac_channel<Params> &paramsIn,
        ac_channel<LoopIndices> &loopIndicesIn)
    {
        #ifndef __SYNTHESIS__
        //assert(params.OX0 * params.OY0 * params.OC1 < ACCUMULATION_BUFFER_SIZE);
        #endif

        #ifndef __SYNTHESIS__
        while(paramsIn.available(1))
        #endif
        {
            // -------------------------------
            // Your code starts here
            // Read in the params and loop indices from the channel
            // -------------------------------
            Params params = paramsIn.read();
            LoopIndices loopIndices = loopIndicesIn.read();
            // -------------------------------
            // Your code ends here
            // -------------------------------


            // -------------------------------
            // Your code starts here
            // Create a loop for a "run" of the systolic array.
            // The number of steps in a run of the systolic array is equal to:
            // the ramp-up time + number of pixels + flush time
            // -------------------------------
            #pragma hls_unroll no
  //          #pragma hls_pipeline_init_interval 1
            LABEL(step) for (uint_16 step = 0; step < OC0+IC0+(params.OX0*params.OY0)-1; ++step) { // loop inside each image tile
            // -------------------------------
            // Your code ends here 
            // You should now be in the body of the loop
            // -------------------------------

                // -------------------------------
                // Your code starts here
                // If you are in the ramp up time, read in weights from the channel
                // and store it in the weights array
                // -------------------------------
                if (step < IC0) {       
                    PackedInt<WEIGHT_PRECISION, OC0> w_row = weight.read();
                    
                    #pragma hls_unroll yes
                    for(int j = 0; j < OC0; j++){
                            weight_reg[step][j] = w_row.value[j];
                    }
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------

                
                PackedInt<INPUT_PRECISION, IC0> in_col;

                // -------------------------------
                // Your code starts here
                // Read inputs from the channel and store in the variable in_col
                // Note: you don't read in any inputs during the flush time
                // -------------------------------
                if (step < (params.OX0*params.OY0)) {        
                    in_col = input.read();
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------
        

                /*
                 * FIFOs for inputs coming in to the systolic array
                 * assign values to in_col, and the skewed version will be in input_buf
                 */
                PackedInt<INPUT_PRECISION, IC0> input_buf;

                #define INPUT_FIFO_BODY(z,i,unused) \
                    IDTYPE BOOST_PP_CAT(input_fifo_output_, i); \
                    IDTYPE BOOST_PP_CAT(input_fifo_input_, i) = in_col.value[i]; \
                    BOOST_PP_CAT(input_fifo_, i).run( BOOST_PP_CAT(input_fifo_input_, i) , BOOST_PP_CAT(input_fifo_output_, i) ); \
                    input_buf.value[i] = BOOST_PP_CAT(input_fifo_output_, i);
                
                REPEAT(INPUT_FIFO_BODY)


                // -------------------------------
                // Your code starts here
                // Assign values from input_buf into the registers for the first column of PEs
                // -------------------------------
                #pragma hls_unroll yes
                LABEL(INIT_IN) for(int i = 0; i < IC0; ++i) {
                    input_reg[i+1][0] = input_buf.value[i];
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------

                PackedInt<OUTPUT_PRECISION, OC0> tmp_output_buf;
                
                // -------------------------------
                // Your code starts here
                // Set partial outputs for the array to tmp_output_buf.
                // Depending on the loop index, the partial output will be 0 or a value from the accumulation buffer
                // -------------------------------
                if(step < (params.OX0*params.OY0)){
                    // initial partial output of 0
                    if(loopIndices.ic1_idx == 0 && loopIndices.fx_idx == 0 && loopIndices.fy_idx == 0) {
                        #pragma hls_unroll yes
                        for(int j = 0; j < OC0; j++){
                            tmp_output_buf.value[j].template set_val<AC_VAL_0>();
                        }
                    }
                    else{ // read partial output from accumulation buffer
                        #pragma hls_unroll yes
                        for(int j = 0; j < OC0; j++){
                            tmp_output_buf.value[j] = accumulation_buffer[step][j];
                        }
                    }
                }
                
                /*
                 * FIFOs for partial outputs coming in to the systolic array
                 * assign values to tmp_output_buf, and the skewed version will be in output_buf
                 */
                PackedInt<OUTPUT_PRECISION, OC0> output_buf;
                #define ACCUM_FIFO_BODY(z,i,unused) \
                    ODTYPE BOOST_PP_CAT(accum_fifo_output_, i); \
                    ODTYPE BOOST_PP_CAT(accum_fifo_input_, i) = tmp_output_buf.value[i]; \
                    BOOST_PP_CAT(accum_fifo_, i).run( BOOST_PP_CAT(accum_fifo_input_, i) , BOOST_PP_CAT(accum_fifo_output_, i) ); \
                    output_buf.value[i] = BOOST_PP_CAT(accum_fifo_output_, i);
                
                REPEAT(ACCUM_FIFO_BODY)
        
                // -------------------------------
                // Your code starts here
                // Assign values from output_buf into the partial sum registers for the first column of PEs
                // -------------------------------
                #pragma hls_unroll yes
                LABEL(INIT_OUT) for(int j = 0; j < OC0; ++j) {
                        psum_reg[0][j+1] = output_buf.value[j];
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------
            

                // -------------------------------
                // Your code starts here
                // Run the 16x16 PE array
                // Make sure that the correct registers are given to the PE
                // -------------------------------
                #pragma hls_unroll yes
                LABEL(COL) for (int j=0; j < OC0; ++j) {
                    #pragma hls_unroll yes
                    LABEL(ROW) for (int i=0; i < IC0; ++i) {
                        pe[i][j].run(input_reg[i+1][j], psum_reg[i][j+1], weight_reg[i][j], input_reg2[i+1][j+1], psum_reg2[i+1][j+1]);
                    } //ROW
                } //COL
                // -------------------------------
                // Your code ends here
                // -------------------------------
                
                /*
                 * FIFOs for partial outputs coming out of the systolic array
                 * The skewed version will be in the variable output_row
                 */
                PackedInt<OUTPUT_PRECISION, OC0> output_row;

                #define FIFO_WRITE_BODY_NEW(z,i,unused)\
                    ODTYPE BOOST_PP_CAT(output_fifo_output_, i); \
                    BOOST_PP_CAT(output_fifo_, i).run( psum_reg[IC0][i+1] , BOOST_PP_CAT(output_fifo_output_, i) );\
                    output_row.value[i] = BOOST_PP_CAT(output_fifo_output_,i); \
                
                REPEAT(FIFO_WRITE_BODY_NEW)

                // -------------------------------
                // Your code starts here
                // After a certain number of cycles, you will have valid output from the systolic array
                // Depending on the loop indices, this valid output will either be written into the accumulation buffer or written out
                // -------------------------------
                if(step >= OC0+IC0-1){
                    #pragma hls_unroll yes
                    for(int i = 0; i < IC0; i++){
                        accumulation_buffer[step-(IC0+OC0-1)][i] = output_row.value[i];
                    }
                    if (loopIndices.ic1_idx==params.IC1-1 && loopIndices.fx_idx == params.FX-1 && loopIndices.fy_idx == params.FY-1) {   
                        output.write(output_row);
                    }
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------
                
                // -------------------------------
                // Your code starts here
                // Cycle the input/psum registers
                // That is, the outputs that a PE wrote to should now become the input for the next PE
                // -------------------------------
                #pragma hls_unroll yes
                for(int j = 0; j < OC0; j++){
                    #pragma hls_unroll yes
                    for(int i = 0; i < IC0; i++){
                        input_reg[i+1][j+1] = input_reg2[i+1][j+1];
                        psum_reg[i+1][j+1] = psum_reg2[i+1][j+1];
                    }
                }
            }
        }
    
    }

private:
    
    // -------------------------------
    // Your code starts here
    // Create the following:
    //  - PE array
    //  - accumulation buffer
    //  - weight registers
    //  - input registers (two sets, one at the input of the PE and one at the output) 
    //  - psum registers (two sets, one at the input of the PE and one at the output) 
    // -------------------------------
    ProcessingElement<IDTYPE, ODTYPE> pe[IC0][OC0];

    ODTYPE accumulation_buffer[ACCUMULATION_BUFFER_SIZE][IC0];
    IDTYPE weight_reg[IC0][OC0];
    IDTYPE input_reg[IC0 + 1][OC0 + 1];
    ODTYPE psum_reg[IC0 + 1][OC0 + 1];
    IDTYPE input_reg2[IC0+1][OC0+1];
    ODTYPE psum_reg2[IC0+1][OC0+1];
    // -------------------------------
    // Your code ends here
    // -------------------------------
    

#define INPUT_FIFOS_INIT(z, i, unused) \
    Fifo<IDTYPE, i + 1> BOOST_PP_CAT(input_fifo_, i);

    REPEAT(INPUT_FIFOS_INIT)

#define ACCUM_FIFOS_INIT(z, i, unused) \
    Fifo<ODTYPE, i + 1> BOOST_PP_CAT(accum_fifo_, i);

    REPEAT(ACCUM_FIFOS_INIT)
    

#define OUTPUT_FIFOS_INIT(z, i, unused) \
    Fifo<ODTYPE, OC0 - i> BOOST_PP_CAT(output_fifo_, i);
    
    REPEAT(OUTPUT_FIFOS_INIT)
};

#endif
