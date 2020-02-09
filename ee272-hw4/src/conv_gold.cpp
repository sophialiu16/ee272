template <typename IDTYPE, 
          typename ODTYPE,
          int OFMAP_HEIGHT, 
          int OFMAP_WIDTH, 
          int OFMAP_CHANNELS, 
          int IFMAP_CHANNELS, 
          int FILTER_SIZE, 
          int STRIDE>
void conv_gold( IDTYPE ifmap[(OFMAP_HEIGHT-1)*STRIDE+FILTER_SIZE][(OFMAP_WIDTH-1)*STRIDE+FILTER_SIZE][IFMAP_CHANNELS],
               IDTYPE weights[FILTER_SIZE][FILTER_SIZE][IFMAP_CHANNELS][OFMAP_CHANNELS],
               ODTYPE ofmap[OFMAP_HEIGHT][OFMAP_WIDTH][OFMAP_CHANNELS]){

  
  ROW:for (int i=0; i < OFMAP_HEIGHT; ++i ) {
    COL:for (int j=0; j < OFMAP_WIDTH; ++j) {
      NK: for (int k=0; k < OFMAP_CHANNELS; ++k) {
        ODTYPE tmp=0;
        ACC:for (int c=0; c < IFMAP_CHANNELS; ++c) { 
          WR: for (int fx=0; fx < FILTER_SIZE; fx++) {
            WC: for (int fy=0; fy < FILTER_SIZE; fy++) {
              tmp += (ODTYPE) ifmap[STRIDE*i+fy][STRIDE*j+fx][c] * (ODTYPE) weights[fy][fx][c][k];
            }
          }
        }
        ofmap[i][j][k]= tmp;
      }
    }
  }
}

