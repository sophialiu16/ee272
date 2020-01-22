`include "layer_params.svh"
extern void run_conv_gold ( input reg [15:0] array  [157323-1:0] ifmap, 
                    input reg [15:0] array [9408-1:0] weights,
                    output reg [31:0] array [802816-1:0] ofmap,
                    input bit [7:0] ofmap_width,
                    input bit [7:0] ofmap_height,
                    input bit [15:0] ifmap_channels,
                    input bit [15:0] ofmap_channels,
                    input bit [3:0] filter_size,
                    input bit [3:0] stride);
module conv_tb
#(
    parameter IFMAP_SIZE = 157323, // ((OFMAP_HEIGHT - 1) * STRIDE + FILTER_SIZE)^2 * IFMAP_CHANNELS
    parameter WEIGHTS_SIZE = 9408, // FILTER_SIZE * FILTER_SIZE * IFMAP_CHANNELS * OFMAP_CHANNELS
    parameter OFMAP_SIZE = 802816, //112*112*64 = OFMAP_HEIGHT * OFMAP_WIDTH * OFMAP_CHANNELS
    parameter OFMAP_WIDTH = 112,
    parameter OFMAP_HEIGHT = 112,
    parameter OFMAP_CHANNELS = 64,
    parameter IFMAP_CHANNELS = 3,
    parameter STRIDE = 2,
    parameter FILTER_SIZE = 7

);
    // START CODE HERE
    // sets the layer parameters for the convolution
  	// sends input and weight arrays into the accelerator
  	// gets the output array and checks it using the gold model
  
reg [31:0] gold_ofmap_mem [OFMAP_SIZE-1:0];
reg [31:0] generated_ofmap_mem [OFMAP_SIZE-1:0];
reg [15:0] ifmap_mem [IFMAP_SIZE-1:0];
reg [15:0] weights_mem [WEIGHTS_SIZE-1:0];
reg [$clog2(OFMAP_SIZE)-1:0] ofmap_idx;
reg [$clog2(IFMAP_SIZE)-1:0] ifmap_idx;
reg [$clog2(WEIGHTS_SIZE)-1:0] weights_idx;
 initial begin
        $readmemh("data/layer1_gold_ofmap.mem", gold_ofmap_mem);
        $readmemh("data/layer1_ifmap.mem", ifmap_mem);
        $readmemh("data/layer1_weights.mem", weights_mem);
    end


  	// TRANSACTION
    class conv_item; 
 
      // ifmap
      rand bit [15:0] ifmap_dat;
      bit ifmap_rdy;
      rand bit ifmap_vld;

      // weights
      rand bit [15:0] weights_dat;
      bit weights_rdy;
      rand bit weights_vld;

      // ofmap
      rand bit [31:0] ofmap_dat;
      bit ofmap_vld;
      rand bit ofmap_rdy;

      // params
      //rand bit [7:0][7:0][15:0][15:0][3:0][3:0] layer_params_dat;
      layer_params_t layer_params_dat;
      bit layer_params_rdy;
      rand bit layer_params_vld;
      
      function void printifmap(string tag="");
        $display ("T=%0t, ifmap data = %0d, ifmap rdy = 0x%0h, ifmap valid = 0x%0h",
                  $time, ifmap_dat, ifmap_rdy, ifmap_vld);
      endfunction
      
      function void printofmap(string tag="");
        $display ("T=%0t, ofmap data = %0d, ofmap rdy = 0x%0h, ofmap valid = 0x%0h",
                  $time, ofmap_dat, ofmap_rdy, ofmap_vld);
      endfunction
       
      function void printweights(string tag="");
        $display ("T=%0t, weights data = %0d, weights rdy = 0x%0h, weights valid = 0x%0h",
                  $time, weights_dat, weights_rdy, weights_vld);
      endfunction      
    endclass
  
  	// DRIVER
    class driver;
        virtual conv_if vif;
        event drv_done;
        mailbox drv_mbx;
	//
	task run();
        $display ("T=%0t [Driver] starting ...", $time);
        @ (posedge vif.clk);
          forever begin
          conv_item item;
          $display ("T=%0t [Driver] waiting for item ...", $time);
          drv_mbx.get(item);

          // ifmap
          if (vif.ifmap_rdy) begin
            vif.ifmap_dat <= item.ifmap_dat;
            vif.ifmap_vld <= 1;
          end
          else begin
            vif.ifmap_dat <= vif.ifmap_dat;
            vif.ifmap_vld <= 0;
          end
          
          // weights
          if (vif.weights_rdy) begin
            vif.weights_dat <= item.weights_dat;
            vif.weights_vld <= 1;
          end
          else begin
            vif.weights_dat <= vif.weights_dat;
            vif.weights_vld <= 0;
          end

      		// ofmap
          if (vif.ofmap_vld) begin
            vif.ofmap_dat <= item.ofmap_dat;
            vif.ofmap_rdy <= 1;
          end
          else begin
            vif.ofmap_dat <= vif.ofmap_dat;
            vif.ofmap_rdy <= 0;
          end

      		// params
          if (vif.layer_params_rdy) begin
            vif.layer_params_dat <= item.layer_params_dat;
            vif.layer_params_vld <= 1;
          end
          else begin
            vif.layer_params_dat <= vif.layer_params_dat;
            vif.layer_params_vld <= 0;
          end

          @ (posedge vif.clk);
          while (!vif.ifmap_vld & !vif.weights_vld & !vif.ofmap_rdy & !vif.layer_params_rdy) begin
            $display ("T=%0t [Driver] wait until ready is high", $time);
            @(posedge vif.clk);
          end

          // When transfer is over, raise the done event
	  //vif.ifmap_vld <= 0;
	  //vif.weights_vld <= 0;
	  //vif.ofmap_rdy <= 0;
	  //vif.layer_params_vld <= 0;
          ->drv_done;
        end
      endtask
  	endclass

  	// MONITOR
    class monitor; 
      virtual conv_if vif;
      mailbox scb_mbx; 
      
      task run(); 
        $display("T=%0t [Monitor] starting ...", $time);
        
        forever begin 
          @ (posedge vif.clk);
          if (vif.ifmap_vld) begin 
            conv_item item = new; 
            item.ifmap_dat = vif.ifmap_dat; 
            item.ifmap_rdy = vif.ifmap_rdy;
            item.printifmap("Monitor, ifmap");
            scb_mbx.put(item);
          end 
          if (vif.weights_vld) begin 
            conv_item item = new; 
            item.weights_dat = vif.weights_dat; 
            item.weights_rdy = vif.weights_rdy; 
            item.printweights("Monitor, weights");
            scb_mbx.put(item);
          end 
          if (vif.ofmap_rdy) begin 
            conv_item item = new; 
            item.ofmap_dat = vif.ofmap_dat; 
            item.ofmap_vld = vif.ofmap_vld;
            item.printofmap("Monitor, ofmap");
            scb_mbx.put(item);
          end 
          if (vif.layer_params_vld) begin 
            conv_item item = new; 
            item.layer_params_dat = vif.layer_params_dat; 
            item.layer_params_rdy = vif.layer_params_rdy;
            //item.print("Monitor, layer param");
            scb_mbx.put(item);
          end 
        end
      endtask
    endclass
      
      initial begin
         run_conv_gold(ifmap_mem,
                  weights_mem,
                  generated_ofmap_mem,
                  OFMAP_WIDTH,
                  OFMAP_HEIGHT,
                  IFMAP_CHANNELS,
                  OFMAP_CHANNELS,
                  FILTER_SIZE,
                  STRIDE);
      end

    // SCOREBOARD
    class scoreboard;
      mailbox scb_mbx;
 
      task run();
      $display ("T=%0t [Scoreboard] starting ...", $time);
        
      forever begin
      conv_item item;
      scb_mbx.get(item);
      //item.print("Scoreboard");
      
      if (item.ofmap_vld) begin
        if (generated_ofmap_mem[ofmap_idx] != gold_ofmap_mem[ofmap_idx]) begin
          $display ("T=%0t [Scoreboard] ERROR!, generated=%0h, gold=%0h", $time, generated_ofmap_mem[ofmap_idx], gold_ofmap_mem[ofmap_idx]);
        end
        else begin
          $display ("T=%0t [Scoreboard] PASS!", $time);
        end
      end
      end 
    endtask
  endclass

    // ENVIRONMENT
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
  
  	// TEST
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
      
      test_layer(); 
    endtask 
    
    virtual task test_layer(); 
      conv_item item; 
      
      $display("T=%0t [Test] Testing layer input ...", $time);
      
      item = new; 
      // get layer 1 input 
      
      item.ifmap_dat = ifmap_mem[ifmap_idx]; 
      item.ifmap_vld = 1;
      item.weights_dat = weights_mem[weights_idx]; 
      item.weights_vld = 1;
      
      drv_mbx.put(item); 
    endtask
  endclass
   

  reg clk;
  
  always #10 clk = ~clk;
  conv_if _if (clk);
  
  conv u0 (.clk (clk),
           //.rst_n (_if.rst_n),
           .ifmap_dat (_if.ifmap_dat),
           .ifmap_rdy(_if.ifmap_rdy),
           .ifmap_vld(_if.ifmap_vld),
           .weights_dat(_if.weights_dat),
           .weights_rdy(_if.weights_rdy),
           .weights_vld(_if.weights_vld), 
           .ofmap_dat (_if.ofmap_dat),
           .ofmap_rdy(_if.ofmap_rdy),
           .ofmap_vld(_if.ofmap_vld),
           .layer_params_dat (_if.layer_params_dat),
           .layer_params_rdy(_if.layer_params_rdy),
           .layer_params_vld(_if.layer_params_vld)); 
  
  initial begin
    test t0; 
    clk <= 0;
    _if.rst_n <= 0;
    _if.ifmap_vld <= 0;
    _if.weights_vld <= 0;
    _if.ofmap_rdy <= 0;
    _if.layer_params_vld <= 0;
    
    #20 _if.rst_n <= 1;
    
    t0 = new;
    t0.e0.vif = _if;
    t0.run();

    #200 $finish;
  end

  initial begin
    $vcdplusfile("dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, conv_tb);
    #2200000;
    $finish(2);
  end

always_ff @(posedge clk, negedge _if.rst_n) begin
      if (~_if.rst_n) begin
        ofmap_idx <= 1'b0;
        ifmap_idx <= 1'b0;
        weights_idx <= 1'b0;
      end
      else begin
	if (_if.ifmap_rdy) begin
	        ifmap_idx <= ifmap_idx + 1'b1;
	end

	if (_if.weights_rdy) begin
	        weights_idx <= weights_idx + 1'b1;
	end

	if (_if.ofmap_vld) begin
		ofmap_idx <= ofmap_idx + 1'b1;
        end
      end
    end

endmodule
        // INTERFACE
  interface conv_if (input bit clk);
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

    //logic [7:0][7:0][15:0][15:0][3:0][3:0] layer_params_dat;
    layer_params_t layer_params_dat;
    //logic [$bits(layer_params_t)-1:0] layer_params_dat;
    //assign layer_params_dat = layer_params_; 

    //logic [$bits(layer_params_t)-1:0] layer_params_t layer_params_dat;
    logic layer_params_rdy;
    logic layer_params_vld;
  endinterface
