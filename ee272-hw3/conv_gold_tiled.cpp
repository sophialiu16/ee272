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

  int OY0 = 4;
  int OY1 = OFMAP_HEIGHT/OY0;
  int OX0 = 4;
  int OX1 = OFMAP_WIDTH/OX0;
  int OC0 = 4; // Make this equal to array width
  int OC1 = OFMAP_CHANNELS/OC0;
  int IC0 = 4; // Make this equal to array height
  int IC1 = IFMAP_CHANNELS/IC0;

  OY: for (int oy = 0; oy < OFMAP_HEIGHT; oy++) {
    OX: for (int ox = 0; ox < OFMAP_WIDTH; ox++) {
      OC: for (int oc = 0; oc < OFMAP_CHANNELS; oc++) {
        ofmap[oy][ox][oc] = 0;
      }
    }
  }

  OY1: for (int oy1 = 0; oy1 < OY1; oy1++) {
    OX1: for (int ox1 = 0; ox1 < OX1; ox1++) {
      OC1: for (int oc1 = 0; oc1 < OC1; oc1++) {
        IC1: for (int ic1 = 0; ic1 < IC1; ic1++) { 
          FY: for (int fy = 0; fy < FILTER_SIZE; fy++) {
            FX: for (int fx = 0; fx < FILTER_SIZE; fx++) {
              OY0: for (int oy0 = 0; oy0 < OY0; oy0++) { 
                OX0: for (int ox0 = 0; ox0 < OX0; ox0++) { 
                  OC0: for (int oc0 = 0; oc0 < OC0; oc0++) { // In hardware this loop is unrolled
                    IC0: for (int ic0 = 0; ic0 < IC0; ic0++) { // In hardware this loop is unrolled
                      int oy = oy1*OY0 + oy0;
                      int ox = ox1*OX0 + ox0;
                      int oc = oc1*OC0 + oc0;
                      int ic = ic1*IC0 + ic0;
                      ofmap[oy][ox][oc] += (int32_t) ifmap[STRIDE*oy+fy][STRIDE*ox+fx][ic] * 
                                           (int32_t) weights[fy][fx][ic][oc];
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

}
