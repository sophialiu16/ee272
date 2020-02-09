#ifndef SERIALIZER_H
#define SERIALIZER_H

template<typename DTYPE, typename DTYPE_SERIAL, int n>
class Serializer{
public:
    Serializer(){}

#pragma hls_design interface
#pragma hls_pipeline_init_interval 1
void CCS_BLOCK(run)(ac_channel<DTYPE> &inputChannel,
                    ac_channel<DTYPE_SERIAL> &serialOutChannel)
    {
        #ifndef __SYNTHESIS__
        while(inputChannel.available(1))
        #endif
        {
            DTYPE input = inputChannel.read();

            #pragma hls_pipeline_init_interval 1
            for(int i = 0; i < n; i++){
                serialOutChannel.write(input.value[i]);
            }
        }
    }
};

#endif
