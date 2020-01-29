`include "layer_params.svh"

// Change these depending on the layer:
`define LAYER_OFMAP_HEIGHT (112)
`define LAYER_OFMAP_WIDTH (112)
`define LAYER_OFMAP_CHANNELS (64)
`define LAYER_IFMAP_CHANNELS (3)
`define LAYER_FILTER_SIZE (7)
`define LAYER_STRIDE (2)

// Don't modify these
`define LAYER_IFMAP_HEIGHT ((`LAYER_OFMAP_HEIGHT-1)*`LAYER_STRIDE+`LAYER_FILTER_SIZE)
`define LAYER_IFMAP_WIDTH ((`LAYER_OFMAP_WIDTH-1)*`LAYER_STRIDE+`LAYER_FILTER_SIZE)
`define LAYER_IFMAP_SIZE (`LAYER_IFMAP_HEIGHT*`LAYER_IFMAP_WIDTH*`LAYER_IFMAP_CHANNELS)
`define LAYER_OFMAP_SIZE (`LAYER_OFMAP_HEIGHT*`LAYER_OFMAP_WIDTH*`LAYER_OFMAP_CHANNELS)
`define LAYER_WEIGHTS_SIZE (`LAYER_FILTER_SIZE*`LAYER_FILTER_SIZE*`LAYER_IFMAP_CHANNELS*`LAYER_OFMAP_CHANNELS)

extern void run_conv_gold ( input reg [15:0] array [`LAYER_IFMAP_SIZE-1:0] ifmap, 
                    input reg [15:0] array [`LAYER_WEIGHTS_SIZE-1:0] weights,
                    output reg [31:0] array [`LAYER_OFMAP_SIZE-1:0] ofmap,
                    input bit [7:0] ofmap_width,
                    input bit [7:0] ofmap_height,
                    input bit [15:0] ifmap_channels,
                    input bit [15:0] ofmap_channels,
                    input bit [3:0] filter_size,
                    input bit [3:0] stride);

interface conv_if(input bit clk);
    logic rst_n;
    
    // ifmap
    logic [15:0] ifmap_dat;
    logic ifmap_rdy;
    logic ifmap_vld;

    // weights
    logic [15:0] weights_dat;
    logic weights_rdy;
    logic weights_vld;

    // ofmap
    logic [31:0] ofmap_dat;
    logic ofmap_rdy;
    logic ofmap_vld;

    // params
    layer_params_t layer_params_dat;
    logic layer_params_rdy;
    logic layer_params_vld;

    task write_ifmap(logic [15:0] ifmap);
        ifmap_dat = ifmap;
        ifmap_vld = 1;
    endtask

    task write_weights(logic [15:0] weights);
        weights_dat = weights; 
        weights_vld = 1;
    endtask

    task write_layer_params(layer_params_t params);
        layer_params_dat = params;
        layer_params_vld = 1;
    endtask

    task read_ofmap(output logic [31:0] ofmap);
        ofmap = ofmap_dat;
    endtask

    task read_ifmap(output logic [15:0] ifmap);
        ifmap = ifmap_dat;
    endtask
    
    task read_weights(output logic [15:0] weights);
        weights = weights_dat;
    endtask

    task read_layer_params(output layer_params_t params);
        params = layer_params_dat;
    endtask
endinterface

class conv_item;
    layer_params_t layer_params;

    reg [15:0] ifmap_dat_full [`LAYER_IFMAP_SIZE-1:0];
    reg [15:0] weights_dat_full [`LAYER_WEIGHTS_SIZE-1:0];
    reg [31:0] ofmap_dat_full [`LAYER_OFMAP_SIZE-1:0];
endclass;

class driver;
    virtual conv_if vif;
    mailbox drv_mbx;
    
    int ifmap_idx;
    int weights_idx;
    logic params;

    task run();
        $display ("T=%0t [Driver] Starting ...", $time);

        forever begin
            conv_item transaction;
            drv_mbx.get(transaction);

            ifmap_idx = 0;
            weights_idx = 0;
            params = 0;
            vif.ofmap_rdy = 1;

            @ (posedge vif.clk);
            @ (posedge vif.clk);

            while(ifmap_idx < `LAYER_IFMAP_SIZE || weights_idx < `LAYER_WEIGHTS_SIZE || params == 0) begin
                if (ifmap_idx < `LAYER_IFMAP_SIZE) begin
                    vif.write_ifmap(transaction.ifmap_dat_full[ifmap_idx]);
                    ifmap_idx = ifmap_idx + 1;
                end
                else begin
                    vif.ifmap_vld = 0;
                end
                
                if (weights_idx < `LAYER_WEIGHTS_SIZE) begin
                    vif.write_weights(transaction.weights_dat_full[weights_idx]);
                    weights_idx = weights_idx + 1;
                end
                else begin
                    vif.weights_vld = 0;
                end

                if(params == 0) begin
                    vif.write_layer_params(transaction.layer_params);
                    params = 1;
                end
                else begin
                    vif.weights_vld = 0;
                end

                @ (posedge vif.clk);
            end
        end
        
    endtask
endclass

class monitor; 
    virtual conv_if vif;
    mailbox scb_mbx; // mailbox connected to scoreboard

    int ifmap_idx;
    int weights_idx;
    logic params_read;
    int ofmap_idx;

    task run();
     $display("T=%0t [Monitor] Starting ...", $time);
        forever begin
            conv_item transaction = new;

            ifmap_idx = 0;
            weights_idx = 0;
            params_read = 0;
            ofmap_idx = 0;

            @ (posedge vif.clk);
            @ (posedge vif.clk);

            while(ifmap_idx < `LAYER_IFMAP_SIZE || weights_idx < `LAYER_WEIGHTS_SIZE || params_read == 0 || ofmap_idx < `LAYER_OFMAP_SIZE) begin
                if (ifmap_idx < `LAYER_IFMAP_SIZE) begin
                    vif.read_ifmap(transaction.ifmap_dat_full[ifmap_idx]);
                    ifmap_idx += 1;
                end
                
                if (weights_idx < `LAYER_WEIGHTS_SIZE) begin
                    vif.read_weights(transaction.weights_dat_full[weights_idx]);
                    weights_idx += 1;
                end

                if(params_read == 0 && vif.layer_params_vld == 1) begin
                    vif.read_layer_params(transaction.layer_params);
                    params_read = 1;
                end

                if(ofmap_idx < `LAYER_OFMAP_SIZE && vif.ofmap_vld == 1) begin
                    vif.read_ofmap(transaction.ofmap_dat_full[ofmap_idx]);
                    ofmap_idx += 1;
                end

                @ (posedge vif.clk);
            end
            
            scb_mbx.put(transaction);
        end
    endtask
endclass

class scoreboard;
    mailbox scb_mbx;

    reg [31:0] gold_ofmap_dat [`LAYER_OFMAP_SIZE-1:0];

    task run();
        forever begin
            conv_item transaction;
            scb_mbx.get(transaction);
            $display("[Scoreboard] Checking transaction...");
            
            run_conv_gold(transaction.ifmap_dat_full, transaction.weights_dat_full, gold_ofmap_dat, transaction.layer_params.ofmap_width, transaction.layer_params.ofmap_height, transaction.layer_params.ifmap_channels, transaction.layer_params.ofmap_channels, transaction.layer_params.filter_size, transaction.layer_params.stride);
            
            for(int i = 0; i < `LAYER_OFMAP_SIZE; i+=1) begin
                if(transaction.ofmap_dat_full[i] != gold_ofmap_dat[i]) begin
                    $display("[%0t] Scoreboard Error!", $time);
                    $display ("idx: 0x%h dut: 0x%h gold: 0x%h", i, transaction.ofmap_dat_full[i], gold_ofmap_dat[i]);
                    $finish;
                end
            end
            $display("[%0t] Scoreboard Success!", $time);
            $finish;
        end
    endtask
endclass

class env;
    driver d0;
    monitor m0;
    scoreboard s0;
    mailbox scb_mbx;
    virtual conv_if vif;

    function new();
        d0 = new; 
        m0 = new;
        s0 = new;
        scb_mbx = new();
    endfunction

    virtual task run();
        d0.vif = vif;
        m0.vif = vif;
        m0.scb_mbx = scb_mbx;
        s0.scb_mbx = scb_mbx;

        fork
            s0.run();
            d0.run();
            m0.run();    
        join_any 
    endtask   
endclass    

class test;
    env e0;
    mailbox drv_mbx;

    function new();
        drv_mbx = new();
        e0 = new();
    endfunction

    virtual task run();
        e0.d0.drv_mbx = drv_mbx;

        fork 
            e0.run();
        join_none

        apply_stim();
    endtask

    virtual task apply_stim();
        conv_item transaction;
        $display ("T=%0t [Test] Starting stimulus ...", $time);

        transaction = new;
        $readmemh("data/layer1_ifmap.mem", transaction.ifmap_dat_full);
        $readmemh("data/layer1_weights.mem", transaction.weights_dat_full);
        
        transaction.layer_params.ofmap_width = `LAYER_OFMAP_WIDTH;
        transaction.layer_params.ofmap_height = `LAYER_OFMAP_HEIGHT;
        transaction.layer_params.ifmap_channels = `LAYER_IFMAP_CHANNELS;
        transaction.layer_params.ofmap_channels = `LAYER_OFMAP_CHANNELS;
        transaction.layer_params.filter_size = `LAYER_FILTER_SIZE;
        transaction.layer_params.stride = `LAYER_STRIDE;
        
        drv_mbx.put(transaction);
    endtask
endclass


module conv_tb;

    reg clk;

    always #10 clk =~clk;
    
    conv_if _if (clk);

    conv #(.IFMAP_SIZE(`LAYER_IFMAP_SIZE), .WEIGHTS_SIZE(`LAYER_WEIGHTS_SIZE), .OFMAP_SIZE(`LAYER_OFMAP_SIZE))
        dut (
            .clk(_if.clk),
            .rst_n(_if.rst_n), 
            .ifmap_dat(_if.ifmap_dat), 
            .ifmap_rdy(_if.ifmap_rdy), 
            .ifmap_vld(_if.ifmap_vld), 
            .weights_dat(_if.weights_dat), 
            .weights_rdy(_if.weights_rdy), 
            .weights_vld(_if.weights_vld), 
            .ofmap_dat(_if.ofmap_dat), 
            .ofmap_rdy(_if.ofmap_rdy), 
            .ofmap_vld(_if.ofmap_vld), 
            .layer_params_dat(_if.layer_params_dat),
            .layer_params_rdy(_if.layer_params_rdy), 
            .layer_params_vld(_if.layer_params_vld)
    );

    initial begin
        test t0;

        clk <= 0;
        _if.rst_n <= 0;
        #20 _if.rst_n <= 1;

        t0 = new(); 
        t0.e0.vif = _if;
        t0.run();
    end
    initial begin
        $vcdplusfile("dump.vcd");
        $vcdplusmemon();
        $vcdpluson(0, conv_tb);
        #20000000;
        $finish(2);
    end

endmodule
