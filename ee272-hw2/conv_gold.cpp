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

  // START CODE HERE

  for (int i = 0; i < OFMAP_HEIGHT; i++) {
    for (int j = 0; j < OFMAP_WIDTH; j++) {
      for (int k = 0; k < OFMAP_CHANNELS; k++) {
        ofmap[i][j][k] = 0;
      }
    }
  }

  for (int k = 0; k < OFMAP_CHANNELS; k++) {
    for (int c = 0; c < IFMAP_CHANNELS; c++) {
      for (int y = 0; y < OFMAP_HEIGHT; y++) {
        for (int x = 0; x < OFMAP_WIDTH; x++) {
          for (int fy = 0; fy < FILTER_SIZE; fy++) {
            for (int fx = 0; fx < FILTER_SIZE; fx++) {
              ofmap[y][x][k] += ifmap[y*STRIDE + fy][x*STRIDE + fx][c] * weights[fy][fx][c][k];
            }
          }
        }
      }
    }
  }

  
  // END CODE HERE
}
