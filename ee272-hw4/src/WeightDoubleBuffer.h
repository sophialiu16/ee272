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
        Params in_params = paramsIn.read();
        uint_32 index;
        
        for (int oy1 = 0; oy1 < in_params.OY1; oy1++) {
          for (int ox1 = 0; ox1 < in_params.OX1; ox1++) {

          chanStruct<PackedInt<WEIGHT_PRECISION, OC0>, size> tmp;
          
          for (int i = 0; i <in_params.FY * in_params.FX * in_params.IC1 * in_params.OC1; i++) {
            for (int j=0; j < OC0; j++){
              tmp.data[i].value[j] = din.read();
            }
          }

          dout.write(tmp);
        }
      }
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
      Params in_params = paramsIn.read();

      uint_32 addr;

	for (int oy1 = 0; oy1 < in_params.OY1; oy1++) {
    	  for (int ox1 = 0; ox1 < in_params.OX1; ox1++) {
      	      PackedInt<WEIGHT_PRECISION, OC0> dout_;
              chanStruct<PackedInt<WEIGHT_PRECISION, OC0>,size> tmp = din.read();

            for (int oc1 = 0; oc1 < in_params.OC1; oc1++) {
              for (int ic1 = 0; ic1 < in_params.IC1; ic1++) { 
	        for (int fy = 0; fy < in_params.FY; fy++) {
	          for (int fx = 0; fx < in_params.FX; fx++) {
                    for (int oy0 = 0; oy0 < in_params.OY0; oy0++) {
                      for (int ox0 = 0; ox0 < in_params.OX0; ox0++) {
	
               //addr = i * in_params.IC1 * in_params.FY * in_params.FX +
              //       j * in_params.FY * in_params.FX +
              //       k * in_params.FX +
              //       l;
             //fy fx ic oc 
/*              addr = fy * in_params.FX * in_params.IC1 * in_params.OC1 + 
                     fx * in_params.IC1 * in_params.OC1 + 
                     ic1 * in_params.OC1 + 
                     oc1;*/
               
              addr = oc1 * in_params.IC1 * in_params.FY * in_params.FX + 
                     ic1 * in_params.FY * in_params.FX + 
                     fy * in_params.FX + 
                     fx; 
//              std::cout << "oc1 " << oc1 << " ic1 " << ic1 << " fy " << fy << " fx " << fx << " oy0 " << oy0 << " ox0 " << ox0 << " addr " << addr << std::endl;
              for (int index = 0; index < OC0; index++) {
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


