#include "DirectC.h"

#include "conv_gold.cpp"

// Change these values to match the SystemVerilog parameters
#define OFMAP_HEIGHT 112
#define OFMAP_WIDTH 112
#define OFMAP_CHANNELS 64
#define IFMAP_CHANNELS 3
#define FILTER_SIZE 7
#define STRIDE 2

extern "C" void run_conv_gold(vc_handle ifmap, 
                      vc_handle weights, 
                      vc_handle ofmap, 
                      vc_handle params_ofmap_width, 
                      vc_handle params_ofmap_height, 
                      vc_handle params_ifmap_channels,
                      vc_handle params_ofmap_channels,
                      vc_handle params_filter_size,
                      vc_handle params_stride);

void run_conv_gold( vc_handle ifmap, 
            vc_handle weights, 
            vc_handle ofmap, 
            vc_handle params_ofmap_width, 
            vc_handle params_ofmap_height,
            vc_handle params_ifmap_channels,
            vc_handle params_ofmap_channels,
            vc_handle params_filter_size,
            vc_handle params_stride
){
  assert(vc_toInteger(params_ofmap_height) == OFMAP_HEIGHT);
  assert(vc_toInteger(params_ofmap_width) == OFMAP_WIDTH);
  assert(vc_toInteger(params_ofmap_channels) == OFMAP_CHANNELS);
  assert(vc_toInteger(params_ifmap_channels) == IFMAP_CHANNELS);
  assert(vc_toInteger(params_filter_size) == FILTER_SIZE);
  assert(vc_toInteger(params_stride) == STRIDE);

  int16_t ifmap_arr[(OFMAP_HEIGHT-1)*STRIDE+FILTER_SIZE][(OFMAP_WIDTH-1)*STRIDE+FILTER_SIZE][IFMAP_CHANNELS];
  int16_t weight_arr[FILTER_SIZE][FILTER_SIZE][IFMAP_CHANNELS][OFMAP_CHANNELS];
  int32_t ofmap_arr[OFMAP_HEIGHT][OFMAP_WIDTH][OFMAP_CHANNELS];

  for(int i = 0; i < (OFMAP_HEIGHT-1)*STRIDE+FILTER_SIZE; i++){
    for(int j = 0; j < (OFMAP_WIDTH-1)*STRIDE+FILTER_SIZE; j++){
      for(int k = 0; k < IFMAP_CHANNELS; k++){
        int idx = i*((OFMAP_WIDTH-1)*STRIDE+FILTER_SIZE)*IFMAP_CHANNELS + j*IFMAP_CHANNELS + k;
        ifmap_arr[i][j][k] = (int16_t) vc_getMemoryInteger(ifmap, idx);
      }
    }
  }

  for(int i = 0; i < FILTER_SIZE; i++){
    for(int j = 0; j < FILTER_SIZE; j++){
      for(int k = 0; k < IFMAP_CHANNELS; k++){
        for(int l = 0; l < OFMAP_CHANNELS; l++){
          int idx = i*FILTER_SIZE*IFMAP_CHANNELS*OFMAP_CHANNELS + j*IFMAP_CHANNELS*OFMAP_CHANNELS + k*OFMAP_CHANNELS + l;
          weight_arr[i][j][k][l] = (int16_t) vc_getMemoryInteger(weights, idx);
        }
      }
    }
  }

  conv_gold<OFMAP_HEIGHT, OFMAP_WIDTH, OFMAP_CHANNELS, IFMAP_CHANNELS, FILTER_SIZE, STRIDE>(ifmap_arr, weight_arr, ofmap_arr);

  for(int i = 0; i < OFMAP_HEIGHT; i++){
    for(int j = 0; j < OFMAP_WIDTH; j++){
      for(int k = 0; k < OFMAP_CHANNELS; k++){
        int idx = i*OFMAP_WIDTH*OFMAP_CHANNELS + j*OFMAP_CHANNELS+k;
        vc_putMemoryInteger(ofmap, idx, ofmap_arr[i][j][k]);
      }
    }
  }
}
