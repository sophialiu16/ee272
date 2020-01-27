typedef struct packed 
{
    logic [7:0] ofmap_width;
    logic [7:0] ofmap_height;
    logic [15:0] ifmap_channels;
    logic [15:0] ofmap_channels;
    logic [3:0] filter_size;
    logic [3:0] stride;
} layer_params_t;