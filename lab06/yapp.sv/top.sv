///////////////////////////////////////////////////////////////////////////////////////////
// File Name : top.sv
// Version   : 0.1
//-------------------top.dv-------------------------------------------------------------
//
//////////////////////////////////////////////////////////////////////////////////////////

`ifndef TOP
`define TOP
  import uvm_pkg ::* ;
  `include "uvm_macros.svh"
  `include "yapp.svh"
  `include  "yapp_seq_lib.sv"
  `include  "router_test_lib.sv"
  module top();
     
    bit reset, clock ;
  
    yapp_if in0 (clock, reset); 
    
    yapp_router dut (
                      .clock(in0.clock),                              
                      .reset(in0.reset),                            
                      .in_data(in0.in_data),                           
                      .in_data_vld(in0.in_data_vld),                     
                      .in_suspend(in0.in_suspend)
                    );    
 
    initial begin
      yapp_vif_config::set(null, "*","vif",in0);    
      run_test("exhaustive_seq_lib");
    end

 
  initial begin
    reset =0;
      #1;
    repeat(2) begin
      reset =1;
     #5;
    end
    reset = 1'b0; 
  end

  initial begin
    dut.suspend_0 = 1'b0;
    dut.suspend_0 = 1'b0;
    dut.suspend_0 = 1'b0;
  end

  //Generate Clock
  always
    #5 clock = ~clock;


  endmodule  

`endif
