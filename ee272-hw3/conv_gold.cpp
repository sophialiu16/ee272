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
void conv_gold( int16_t ifmap[(OFMAP_HEIGHT-1)*STRIDE+FILTER_SIZE][(OFMAP_WIDTH-1)*STRIDE+FILTER_SIZE][IFMAP_CHANNELS],
               int16_t weights[FILTER_SIZE][FILTER_SIZE][IFMAP_CHANNELS][OFMAP_CHANNELS],
               int32_t ofmap[OFMAP_HEIGHT][OFMAP_WIDTH][OFMAP_CHANNELS]){

  
  ROW:for (int i=0; i < OFMAP_HEIGHT; ++i ) {
    COL:for (int j=0; j < OFMAP_WIDTH; ++j) {
      NK: for (int k=0; k < OFMAP_CHANNELS; ++k) {
        int32_t tmp=0;
        ACC:for (int c=0; c < IFMAP_CHANNELS; ++c) { 
          WR: for (int fx=0; fx < FILTER_SIZE; fx++) {
            WC: for (int fy=0; fy < FILTER_SIZE; fy++) {
              tmp += (int32_t) ifmap[STRIDE*i+fy][STRIDE*j+fx][c] * (int32_t) weights[fy][fx][c][k];
            }
          }
        }
        ofmap[i][j][k]= tmp;
      }
    }
  }
}
