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
#pragma hls_pipeline_init_interval 1
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
            Params in_params = paramsIn.read();           
            LoopIndices in_loopindices = loopIndicesIn.read();
            // -------------------------------
            // Your code ends here
            // -------------------------------


            // -------------------------------
            // Your code starts here
            // Create a loop for a "run" of the systolic array.
            // The number of steps in a run of the systolic array is equal to:
            // the ramp-up time + number of pixels + flush time
            // -------------------------------
            for (int step = 0; step < in_params.ARRAY_DIMENSION * (2 + in_params.ARRAY_DIMENSION); step++) {
            // -------------------------------
            // Your code ends here 
            // You should now be in the body of the loop
            // -------------------------------

                // -------------------------------
                // Your code starts here
                // If you are in the ramp up time, read in weights from the channel
                // and store it in the weights array
                // -------------------------------
                if (step < in_params.ARRAY_DIMENSION) {
                  PackedInt<WEIGHT_PRECISION, OC0> weights_arr = weight.read();
                  for (int i = 0; i < IC0; i++) {
                    for (int j = 0; j < OC0; j++) {
                      pe_weight_in[i][j] = weights_arr[j]
                    }
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
                if (step < in_params.array_dimension * (1 + in_params.array_dimension)) {
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
                for (int i = 0; i < IC0; i++) {
                  for (int j = 1; j < OC0; j++) {
                    pe_ifmap_in[i][j] = pe_ifmap_out[i][j - 1];
                  }
                }

                for (int i = 0; i < IC0; i++) {
                  pe_ifmap_in[i][0] = input_buf[i];
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
                
                // just for first row pes, rest of pes in other rows will get partial output from the PE above them
                for (int i = 0; i < OC0; i++) {
                  // set fifo inputs after array_dimension has passed 
                  if (step >= in_params.ARRAY_DIMENSION && steps < in_params.array_dimension * (1 + in_params.array_dimension) { 
                    tmp_output_buf[i] = pe_psum_out[IC0 - 1][i]
                  } else {
                    tmp_output_buf[i] = 0;
                  }
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------
                
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
                 
                // just for first row pes, rest of pes in other rows will get partial output from the PE above them
                for (int i = 0; i < OC0; i++) {
		  pe_psum_in[0][i] = output_buf[i];
                }

                // -------------------------------
                // Your code ends here
                // -------------------------------
            

                // -------------------------------
                // Your code starts here
                // Run the 16x16 PE array
                // Make sure that the correct registers are given to the PE
                // -------------------------------
               
                for (int i = 0; i < IC0; i++) {
                  for (int j = 0; j < OC0; j++) {
                    (pe_array[i][j]).run(pe_ifmap_in[i][j], pe_psum_in[i][j], pe_weight_in[i][j])
                  }
                }
   
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
                
                // after 2*array_dimension, there will be output from the skewing fifos
                if (step >= 2*in_params.ARRAY_DIMENSION){
                  if (in_loopindices.fx_idx == FX - 1 && in_loopindices.fy_idx == FY - 1){ 
                    // write out 
                    output = output_buf;
                  } else {
                    // write to accumulation buffer
                     
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
                for (int i = 1; i < IC0; i++) {
                  for (int j = 0; j < OC0; j++) {
                    pe_psum_in[i][j] = pe_psum_out[i - 1][j];
                  }
                }
                // -------------------------------
                // Your code ends here
                // -------------------------------
            
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

    // weight registers, two sets of input registers, two sets of psum registers
    IDTYPE pe_ifmap_in[IC0][OC0];
    IDTYPE pe_ifmap_out[IC0][OC0];
    ODTYPE pe_psum_in[IC0][OC0];
    ODTYPE pe_psum_out[IC0][OC0];
    WDTYPE pe_weight_in[IC0][OC0];
    
    accum_buffer[OC0][OX0 * OY0]
    
    ProcessingElement pe_array[IC0][OC0];

    ProcessingElement pe;

    // to do sounds like we should set pe inputs/outputs in above loop so maybe this is not needed?
    // to do what does create PE array mean?
    for (int i = 0; i < IC0; i++) {
      for (int j = 0; j < OC0; j++) {
        pe_array[i][j] = pe;               
      }
    }
    
    // create accumulation buffer - is it not a double buffer in this implementation?
    
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
