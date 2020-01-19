#include <stdio.h>
#include <cassert>
#include <string.h>
#include <cstdint>

template <int OFMAP_HEIGHT, 
          int OFMAP_WIDTH, 
          int OFMAP_CHANNELS, 
          int IFMAP_CHANNELS, 
          int FILTER_SIZE, 
          int STRIDE>
void conv_gold( int16_t ifmap[(OFMAP_HEIGHT*STRIDE+FILTER_SIZE-1)][(OFMAP_WIDTH*STRIDE+FILTER_SIZE-1)][IFMAP_CHANNELS],
               int16_t weights[FILTER_SIZE][FILTER_SIZE][IFMAP_CHANNELS][OFMAP_CHANNELS],
               int32_t ofmap[OFMAP_HEIGHT][OFMAP_WIDTH][OFMAP_CHANNELS]){

  // START CODE HERE
  
  // END CODE HERE
}
