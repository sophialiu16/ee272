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
        Params in_params = paramsIn.read();

        uint_16 IY0 = in_params.STRIDE * (in_params.OY0 - 1) + in_params.FY;
        uint_16 IX0 = in_params.STRIDE * (in_params.OX0 - 1) + in_params.FX;

        for (int oy1 = 0; oy1 < in_params.OY1; oy1++) {
	  for (int ox1 = 0; ox1 < in_params.OX1; ox1++) {
              chanStruct<PackedInt<INPUT_PRECISION,IC0>,size> tmp;
              
              for (int i = 0; i < in_params.IC1 * IY0 * IX0; i++) {
                for (int j = 0; j < IC0; j++){
                  tmp.data[i].value[j] = din.read();
                }
              }
              dout.write(tmp);
          }
        }
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

        Params in_params = paramsIn.read();
        uint_32 ix0, iy0, addr;

        uint_16 IY0 = in_params.STRIDE * (in_params.OY0 - 1) + in_params.FY;
        uint_16 IX0 = in_params.STRIDE * (in_params.OX0 - 1) + in_params.FX;
        for (int oy1 = 0; oy1 < in_params.OY1; oy1++) {
          for (int ox1 = 0; ox1 < in_params.OX1; ox1++) {
 		chanStruct<PackedInt<INPUT_PRECISION, IC0>, size> tmp;
                tmp = din.read();
       
    	   for (int oc1 = 0; oc1 < in_params.OC1; oc1++) {
	     for (int ic1 = 0; ic1 < in_params.IC1; ic1++) {
                for (int fy = 0; fy < in_params.FY; fy++) {
                  for (int fx = 0; fx < in_params.FX; fx++) {
                    for (int oy0 = 0; oy0 < in_params.OY0; oy0++) {
                      for (int ox0 = 0; ox0 < in_params.OX0; ox0++) {
                        ix0 = in_params.STRIDE * ox0 + fx;
                        iy0 = in_params.STRIDE * oy0 + fy;
                        addr = ic1 * IX0 * IY0 + iy0 * IX0 + ix0;
                        PackedInt<INPUT_PRECISION, IC0> dout_;
                        for (int index = 0; index < IC0; index++) {
             		  dout_.value[index] = tmp.data[addr].value[index];
			}
                        dout.write(dout_);
		      }
                    }
                  }
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
        // the memory size must be big enough for 1 block to fit
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

#endif
