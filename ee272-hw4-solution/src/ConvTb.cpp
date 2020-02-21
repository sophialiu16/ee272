#include "conv.h"
#include "conv_gold.cpp"
#include "Conv.cpp"


template <int OFMAP_HEIGHT, 
          int OFMAP_WIDTH, 
          int OFMAP_CHANNELS, 
          int IFMAP_CHANNELS, 
          int FILTER_SIZE, 
          int STRIDE,
          int IC0,
          int OC0>
void run_layer(Params params){
    IDTYPE input[(OFMAP_HEIGHT-1)*STRIDE+FILTER_SIZE][(OFMAP_WIDTH-1)*STRIDE+FILTER_SIZE][IFMAP_CHANNELS]; 
    WDTYPE weight[FILTER_SIZE][FILTER_SIZE][IFMAP_CHANNELS][OFMAP_CHANNELS]; 
    ODTYPE output_ref[OFMAP_HEIGHT][OFMAP_WIDTH][OFMAP_CHANNELS];

    static ac_channel<PackedInt<INPUT_PRECISION, 2> > input_stream;
    static ac_channel<PackedInt<WEIGHT_PRECISION, 2> > weight_stream;
    static ac_channel<ODTYPE> output_stream;
    
    int errCnt = 0;
    printf("Generating Input\n");

    // initialize input image  
    for (int row = 0; row < OFMAP_HEIGHT + FILTER_SIZE -1; row++) {
      for (int col = 0; col < OFMAP_WIDTH + FILTER_SIZE -1; col++) {
        for (int c = 0; c < IFMAP_CHANNELS; c++) {
          input[row][col][c] = (IDTYPE)rand(); 
        }
      }
    }
  
    // streaming input to the interface
    for (int ro = 0; ro < params.OY1; ro++) {
      for (int co = 0; co < params.OX1; co++) {
        for (int c=0; c< params.IC1; c++) {
          for (int p = 0; p < STRIDE*(params.OY0-1) + FILTER_SIZE; p++ ){
            for (int j = 0; j < (STRIDE*(params.OX0-1) + FILTER_SIZE); j++ ){
                for (int i = 0; i < IC0/2; i++ ){
                  PackedInt<INPUT_PRECISION, 2> input_tmp;
                  for(int ii = 0; ii < 2; ii++){
                    input_tmp.value[ii] = input[ro*STRIDE*params.OY0+p][co*STRIDE*params.OX0+j][c*IC0+i*2+ii];
                  }
                  input_stream.write(input_tmp);
                }  // for i
            }  // for j 
          }  // for p
        }  // for c
      }  // for co
    }  // for ro
 

    printf("Generating Weight\n");

    // initialize weights
    for (int wy = 0; wy < FILTER_SIZE; wy++) {  
      for (int wx = 0; wx < FILTER_SIZE; wx++) {  
        for (int c = 0; c < IFMAP_CHANNELS; c++) {
          for (int k = 0; k < OFMAP_CHANNELS; k++) {
            weight[wy][wx][c][k] = (IDTYPE)rand();  
          }
        }  
      }
    }
    
    // streaming weight to the interface
    for (int ro = 0; ro < params.OY1; ro++) {
      for (int co = 0; co < params.OX1; co++) {     
        for(int koo = 0; koo < params.OC1; koo++){
          for (int c = 0; c < params.IC1; c++) {
            for (int wy = 0; wy <params.FY; wy++) {
              for (int wx = 0; wx <params.FX; wx++) {
                for ( int i = 0; i < IC0; i++ ){
                    for ( int j = 0; j < OC0/2; j++ ){
                      PackedInt<WEIGHT_PRECISION, 2> weight_tmp;
                      for(int jj = 0; jj < 2; jj++){
                        weight_tmp.value[jj] = weight[wy][wx][c*IC0+i][koo*OC0 + j*2+jj];
                      }
                      weight_stream.write(weight_tmp);
                    }  // for j
                }  // for i
              }  // for wy
            }  // for wx
          }  // for k
        } // for koo
      }  // for co
    }  // for ko 

    // ac_channel<Params> params_stream;
    // params_stream.write(params);

    static ac_channel<uint_16> params_stream;
    params_stream.write(params.OY1);
    params_stream.write(params.OX1);
    params_stream.write(params.OY0);
    params_stream.write(params.OX0);
    params_stream.write(params.OC1);
    params_stream.write(params.IC1);
    params_stream.write(params.FX);
    params_stream.write(params.FY);
    params_stream.write(params.STRIDE);

    // Main function call
    // launch hardware design
    // conv *conv_design = new conv;
    Conv conv_design;
    conv_design.run(input_stream,weight_stream,output_stream, params_stream);

    // run reference model
    conv_gold<IDTYPE,ODTYPE,OFMAP_HEIGHT,OFMAP_WIDTH,OFMAP_CHANNELS,IFMAP_CHANNELS,FILTER_SIZE,STRIDE>(input, weight, output_ref);          

    printf("\nChecking Output\n\n"); 
    // compare the hardware results with the reference model
    for (int ro = 0; ro < params.OY1; ro++) {
      for (int co = 0; co < params.OX1; co++) {
        for(int koo = 0; koo < params.OC1; koo++){
          for (int p = 0; p < params.OY0; p++ ){
            for (int i = 0; i < params.OX0; i++ ){
              for (int j = 0; j < OC0; j++) {
                
                ODTYPE out_value = output_stream.read();
                
                if((long long)output_ref[ro*params.OY0+p][co*params.OX0+i][koo*OC0+j] != (long long)out_value) {
                  printf("***ERROR***\n");
                  
                  errCnt++;
                  printf("output[%d][%d][%d] = %lld, ref = %lld\n",ro*params.OY0+p, co*params.OX0+i, koo*OC0+j, (long long)out_value, (long long)output_ref[ro*params.OY0+p][co*params.OX0+i][koo*OC0+j]);
                }
              }  // for j
            }  // for i
          }  // for p
        } // for koo
      }  // for co
    }  // for ko
    
    printf("\nThere were %d errors\n",errCnt);
}

CCS_MAIN(int argc, char *argv[]) 
{
    Params params = {
        7, // OY1
        7, // OX1
        8, // OY0
        8, // OX0
        4, // OC1 
        4, // IC1
        3, // FX
        3, // FY
        1 // STRIDE
    };
    run_layer<56, 56, 64, 64, 3, 1, 16, 16>(params);
    // run_layer<28, 28, 128, 128, 3, 1>();

    CCS_RETURN(0);
}
