#ifndef INPUT_DOUBLE_BUFFER_H
#define INPUT_DOUBLE_BUFFER_H

template <int size, int IC0, int OC0>
class InputDoubleBufferWriter{
public:
    InputDoubleBufferWriter(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<Params> &paramsIn,
                        ac_channel<IDTYPE> &din,
                        ac_channel<chanStruct<PackedInt<INPUT_PRECISION,IC0>,size> > &dout)
    {
        chanStruct tmp;
        Params in_params = paramsIn.read();
                              	      	      
        uint_16 IY0 = in_params.STRIDE * (in_params.OY0 - 1) + in_params.FY;
        uint_16 IX0 = in_params.STRIDE * (in_params.OX0 - 1) + in_params.FX;
                              	      	            	      	      	
        WRITE: for (int i = 0; i < in_params.IC1 * IY0 * IX0; i++) {
            tmp.data[i] = din.read();
        }
        dout.write(tmp);
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
        chanStruct tmp = din.read();

        Params in_params = paramsIn.read();
        uint_32 ix0, iy0, addr;	

        uint_16 IY0 = in_params.STRIDE * (in_params.OY0 - 1) + in_params.FY;
        uint_16 IX0 = in_params.STRIDE * (in_params.OX0 - 1) + in_params.FX;

        for (int i = 0; i < in_params.IC1; i++) {
            for (int j = 0; j < in_params.FY; j++) {
                for (int k = 0; k < in_params.FX; k++) {
                    for(int l = 0; l < in_params.OY0; l++){
                        for (int m = 0; m < in_params.OX0; m++) {
                            ix0 = in_params.STRIDE * m + k;
                            iy0 = in_params.STRIDE * l + j;
                            addr = i * IX0 * IY0 + iy0 * IX0 + ix0; 
                            int tmp1 = tmp.data[addr];
                            dout.write(tmp1);
                        }
                    }
                }
            }
        }
    }
};

template <int size, int IC0, int OC0>
class InputDoubleBuffer{
public:
    InputDoubleBuffer(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<IDTYPE> &inputs_in, 
                        ac_channel<PackedInt<INPUT_PRECISION, IC0> > &inputs_out,
                        ac_channel<Params> &paramsIn)
    {
        Params params = paramsIn.read();


        #ifndef __SYNTHESIS__
        ac_int<ac::log2_ceil<size>::val, false> block_size = params.IC1*(params.STRIDE*(params.OX0-1)+params.FX)*(params.STRIDE*(params.OY0-1)+params.FY);
        // The memory size must be big enough for 1 block to fit 
        assert(block_size <= size);
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


