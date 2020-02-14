#ifndef WEIGHT_DOUBLE_BUFFER_H
#define WEIGHT_DOUBLE_BUFFER_H

template <int size, int IC0, int OC0>
class WeightDoubleBufferWriter{
public:
    WeightDoubleBufferWriter(){}

    #pragma hls_design interface
    void CCS_BLOCK(run)(ac_channel<Params> &paramsIn,
                        ac_channel<WDTYPE> &din,
                        ac_channel<chanStruct<PackedInt<WEIGHT_PRECISION, OC0>, size> > &dout)
    {
        chanStruct<PackedInt<WEIGHT_PRECISION, OC0>, size> tmp;
        Params in_params = paramsIn.read();

        uint_32 index;

        for (int i = 0; i < in_params.OC1 * in_params.IC1 * in_params.FY * in_params.FX; i++) {
          tmp.data[i] = din.read();
        }
        
        dout.write(tmp);
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
      chanStruct<PackedInt<WEIGHT_PRECISION, OC0>,size> tmp = din.read();
      Params in_params = paramsIn.read();
      uint_32 addr;
      for (int i = 0; i < in_params.OC1; i++){
        for (int j = 0; j < in_params.IC1; j++){
          for (int k = 0; k < in_params.FY; k++){
            for (int l = 0; l < in_params.FX; l++){
              addr = i * in_params.IC1 * in_params.FY * in_params.FX +
                                                j * in_params.FY * in_params.FX +
                                                k * in_params.FX +
                                                l;
              int tmp1 = tmp.data[addr];
              dout.write(tmp1);
            }
          }
        }
      }
    }
};

template <int size, int IC0, int OC0>
class WeightDoubleBuffer{
public:
  WeightDoubleBuffer(){}

  #pragma hls_design interface
  void CCS_BLOCK(run)(ac_channel<WDTYPE> &weights_in, 
                      ac_channel<PackedInt<WEIGHT_PRECISION, OC0> > &weights_out,
                      ac_channel<Params> &paramsIn)
    {
        Params params = paramsIn.read();

        #ifndef __SYNTHESIS__
            ac_int<ac::log2_ceil<size>::val, false> block_size = IC0*params.OC1*params.FX*params.FY;
            assert(block_size <= size);
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


