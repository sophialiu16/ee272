#ifndef INPUT_DOUBLE_BUFFER_H
#define INPUT_DOUBLE_BUFFER_H

template <int size, int IC0, int OC0>
class InputDoubleBufferWriter{
public:
    InputDoubleBufferWriter(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<Params> &paramsIn,
                        ac_channel<PackedInt<INPUT_PRECISION, 2> > &din,
                        ac_channel<chanStruct<PackedInt<INPUT_PRECISION,IC0>,size> > &dout)
    {
        // -------------------------------
        // Your code starts here
        // -------------------------------
        Params params = paramsIn.read();
        
        uint_32 total_blocks = params.OX1*params.OY1;
        ac_int<ac::log2_ceil<size>::val, false> block_size = params.IC1*(params.STRIDE*(params.OX0-1)+params.FX)*(params.STRIDE*(params.OY0-1)+params.FY);

        while(total_blocks > 0){
            chanStruct<PackedInt<INPUT_PRECISION,IC0>,size> tmp;

            ac_int<ac::log2_ceil<size>::val, false> current_buffer_size = 0;
            
            while(total_blocks > 0 &&  (current_buffer_size+block_size <= size ) ){
                
                for(ac_int<ac::log2_ceil<size>::val, false> idx = 0; idx < block_size; idx++){
                    PackedInt<INPUT_PRECISION,IC0> column;
                    #pragma hls_pipeline_init_interval 1
                    for(int ic0_idx = 0; ic0_idx < IC0/2; ic0_idx++){
                        PackedInt<INPUT_PRECISION, 2> tmp = din.read();

                        #pragma hls_unroll yes
                        for(int i = 0; i < 2; i++){
                            column.value[2*ic0_idx+i] = tmp.value[i];
                        }
                    }

                    #pragma hls_unroll yes
                    for(int i = 0; i < IC0; i++){
                        tmp.data[current_buffer_size+idx].value[i] = column.value[i];
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
class InputDoubleBufferReader{
public:
    InputDoubleBufferReader(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<Params> &paramsIn,
                        ac_channel<chanStruct<PackedInt<INPUT_PRECISION, IC0>,size> > &din, 
                        ac_channel<PackedInt<INPUT_PRECISION, IC0> > &dout)
    {
        // -------------------------------
        // Your code starts here
        // -------------------------------
        Params params = paramsIn.read();
        uint_32 total_blocks = params.OX1*params.OY1;
        ac_int<ac::log2_ceil<size>::val, false> block_size = params.IC1*(params.STRIDE*(params.OX0-1)+params.FX)*(params.STRIDE*(params.OY0-1)+params.FY);

        while(total_blocks > 0){
            chanStruct<PackedInt<INPUT_PRECISION, IC0>, size> tmp = din.read();
            ac_int<ac::log2_ceil<size>::val, false> current_buffer_size = 0;
            uint_32 block_count = 0;

            while(total_blocks > 0 && (current_buffer_size + block_size) <= size){
                #pragma hls_pipeline_init_interval 1
                for(uint_16 koo_idx = 0; koo_idx < params.OC1; koo_idx++){
                    for(uint_16 co_idx = 0; co_idx < params.IC1; co_idx++){
                        for (uint_16 wx_idx = 0; wx_idx < params.FX; wx_idx++) {
                            for (uint_16 wy_idx = 0; wy_idx < params.FY; wy_idx++) {
                                for (uint_16 x_idx=0; x_idx < params.OY0; x_idx++) {
                                    for (uint_16 y_idx=0; y_idx < params.OX0; y_idx++) {
                                        ac_int<ac::log2_ceil<size>::val, false> address = (block_count*block_size) +
                                                        (co_idx*(params.STRIDE*(params.OX0-1)+params.FX)*(params.STRIDE*(params.OY0-1)+params.FY)) +
                                                        (
                                                            (params.STRIDE*x_idx+wx_idx)*(params.STRIDE*(params.OX0-1)+params.FX) +
                                                            (params.STRIDE*y_idx) +
                                                            wy_idx
                                                        );
                        
                                        PackedInt<INPUT_PRECISION, IC0> dout_struct = tmp.data[address];
                                        dout.write(dout_struct);
                                    }
                                }
                            }
                        }
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
class InputDoubleBuffer{
public:
  InputDoubleBuffer(){}

  #pragma hls_design interface
  void CCS_BLOCK(run)(ac_channel<PackedInt<INPUT_PRECISION, 2> > &inputs_in, 
                      ac_channel<PackedInt<INPUT_PRECISION, IC0> > &inputs_out,
                      ac_channel<Params> &paramsIn)
    {
        Params params = paramsIn.read();

        
        #ifndef __SYNTHESIS__
        // ac_int<ac::log2_ceil<size>::val, false> block_size = params.IC1*(params.STRIDE*(params.OX0-1)+params.FX)*(params.STRIDE*(params.OY0-1)+params.FY);
        // The memory size must be big enough for 1 block to fit
        // assert(block_size <= size);
        #endif

        inputDoubleBufferReaderParams.write(params);
        inputDoubleBufferWriterParams.write(params);

        inputDoubleBufferWriter.run(inputDoubleBufferWriterParams, inputs_in, mem);
        inputDoubleBufferReader.run(inputDoubleBufferReaderParams, mem, inputs_out);
    }

private:
    ac_channel<chanStruct<PackedInt<INPUT_PRECISION, IC0>,size> > mem;
    
    InputDoubleBufferWriter<size, IC0, OC0> inputDoubleBufferWriter;
    ac_channel<Params> inputDoubleBufferWriterParams;
    
    InputDoubleBufferReader<size, IC0, OC0> inputDoubleBufferReader;
    ac_channel<Params> inputDoubleBufferReaderParams;
};

#endif
