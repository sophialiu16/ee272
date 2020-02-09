#ifndef DESERIALIZER_H
#define DESERIALIZER_H

template<typename DTYPE_SERIAL, typename DTYPE, int n>
class Deserializer{
public:
    Deserializer(){}

#pragma hls_design interface
void CCS_BLOCK(run)(ac_channel<DTYPE_SERIAL> &inputChannel,
                    ac_channel<DTYPE> &outputChannel)
    {
        #ifndef __SYNTHESIS__
        while(inputChannel.available(1))
        #endif
        {
            DTYPE output;
            #pragma hls_pipeline_init_interval 1
            for(int i = 0; i < n; i++){
                output.value[i] = inputChannel.read();
            }
            outputChannel.write(output);

        }
    }
};

class ParamsDeserializer{
public:
    ParamsDeserializer(){}

#pragma hls_design interface
void CCS_BLOCK(run)(ac_channel<uint_16> &inputChannel,
                    ac_channel<Params> &outputChannel1,
                    ac_channel<Params> &outputChannel2,
                    ac_channel<Params> &outputChannel3)
    {
        Params params;
        
        params.OY1 = inputChannel.read();
        params.OX1 = inputChannel.read();
        params.OY0 = inputChannel.read();
        params.OX0 = inputChannel.read();
        params.OC1 = inputChannel.read();
        params.IC1 = inputChannel.read();
        params.FX = inputChannel.read();
        params.FY = inputChannel.read();
        params.STRIDE = inputChannel.read();

        outputChannel1.write(params);
        outputChannel2.write(params);
        outputChannel3.write(params);
    }

};

#endif
