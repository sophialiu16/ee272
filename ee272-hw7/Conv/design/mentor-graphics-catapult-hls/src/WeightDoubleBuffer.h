#ifndef WEIGHT_DOUBLE_BUFFER_H
#define WEIGHT_DOUBLE_BUFFER_H

template <int size, int IC0, int OC0>
class WeightDoubleBufferWriter{
public:
    WeightDoubleBufferWriter(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<Params> &paramsIn,
                        ac_channel<PackedInt<WEIGHT_PRECISION, 2> > &din,
                        ac_channel<chanStruct<PackedInt<WEIGHT_PRECISION, OC0>, size> > &dout)
    {
        // -------------------------------
        // Your code starts here
        // -------------------------------
        Params params = paramsIn.read();
        uint_64 total_blocks = params.OX1 * params.OY1 * params.IC1 * params.OC1;
        ac_int<ac::log2_ceil<size>::val, false> block_size = IC0*params.FX*params.FY;

        while(total_blocks > 0){
            chanStruct<PackedInt<WEIGHT_PRECISION, OC0>, size> tmp;

            ac_int<ac::log2_ceil<size>::val, false> current_buffer_size = 0;
            
            while(total_blocks > 0 &&  (current_buffer_size+block_size <= size ) ){
                
                for(ac_int<ac::log2_ceil<size>::val, false> idx = 0; idx < block_size; idx++){
                    PackedInt<WEIGHT_PRECISION,OC0> row;

                    #pragma hls_pipeline_init_interval 1
                    for(int oc0_idx = 0; oc0_idx < OC0/2; oc0_idx++){
                        PackedInt<WEIGHT_PRECISION,2> tmp = din.read();
                       
                        #pragma hls_unroll yes
                        for(int i = 0; i < 2; i++){
                            row.value[2*oc0_idx+i] = tmp.value[i];
                            
                        }
                    }

                    #pragma hls_unroll yes
                    for(int i = 0; i < IC0; i++){
                       tmp.data[current_buffer_size+idx].value[i] = row.value[i];
                    }
                }

                total_blocks--;
                current_buffer_size += block_size;
            }
            dout.write(tmp);
        }
        // -------------------------------
        // Your code ends here
        // -------------------------------
    }
};

template <int size, int IC0, int OC0>
class WeightDoubleBufferReader{
public:
    WeightDoubleBufferReader(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<Params> &paramsIn,
                        ac_channel<chanStruct<PackedInt<WEIGHT_PRECISION, OC0>,size> > &din, 
                        ac_channel<PackedInt<WEIGHT_PRECISION, OC0> > &dout)
    {
        // -------------------------------
        // Your code starts here
        // -------------------------------
        Params params = paramsIn.read();

        uint_64 total_blocks = params.OX1 * params.OY1 * params.IC1*params.OC1;
        ac_int<ac::log2_ceil<size>::val, false> block_size = IC0*params.FX*params.FY;

        while(total_blocks > 0){
            chanStruct<PackedInt<WEIGHT_PRECISION, OC0>,size> tmp = din.read();
            ac_int<ac::log2_ceil<size>::val, false> current_buffer_size = 0;
            
            uint_64 block_count = 0;
            
            while(total_blocks > 0 && (current_buffer_size+block_size <= size)){
                #pragma hls_pipeline_init_interval 1
                for (uint_32 wx_idx = 0; wx_idx < params.FX*params.FY; wx_idx++){
                    for (uint_16 r_idx = 0; r_idx < IC0; r_idx++){
                        ac_int<ac::log2_ceil<size>::val, false> address = block_count*block_size
                                        + 
                                        (
                                            (wx_idx*IC0) + 
                                            (r_idx) 
                                        );
                        PackedInt<WEIGHT_PRECISION, OC0> dout_struct = tmp.data[address];
                        dout.write(dout_struct);
                    }
                }
                block_count++;
                total_blocks--;
                current_buffer_size += block_size;
            }
        }
        // -------------------------------
        // Your code ends here
        // -------------------------------
    }
};

template <int size, int IC0, int OC0>
class WeightDoubleBuffer{
public:
  WeightDoubleBuffer(){}

  #pragma hls_design interface
  void CCS_BLOCK(run)(ac_channel<PackedInt<WEIGHT_PRECISION, 2> > &weights_in, 
                      ac_channel<PackedInt<WEIGHT_PRECISION, OC0> > &weights_out,
                      ac_channel<Params> &paramsIn)
    {
        Params params = paramsIn.read();

        #ifndef __SYNTHESIS__
            // ac_int<ac::log2_ceil<size>::val, false> block_size = IC0*params.OC1*params.FX*params.FY;
            // assert(block_size <= size);
        #endif

        weightDoubleBufferReaderParams.write(params);
        weightDoubleBufferWriterParams.write(params);

        weightDoubleBufferWriter.run(weightDoubleBufferWriterParams, weights_in, mem);
        weightDoubleBufferReader.run(weightDoubleBufferReaderParams, mem, weights_out);
    }

private:
    ac_channel<chanStruct<PackedInt<WEIGHT_PRECISION, OC0>,size> > mem;
    
    WeightDoubleBufferWriter<size, IC0, OC0> weightDoubleBufferWriter;
    ac_channel<Params> weightDoubleBufferWriterParams;
    
    WeightDoubleBufferReader<size, IC0, OC0> weightDoubleBufferReader;
    ac_channel<Params> weightDoubleBufferReaderParams;
};


#endif
