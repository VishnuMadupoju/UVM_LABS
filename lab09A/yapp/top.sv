///////////////////////////////////////////////////////////////////////////////////////////
// File Name : top.sv
// Version   : 0.1
//-------------------top.dv-------------------------------------------------------------
//
//////////////////////////////////////////////////////////////////////////////////////////

`ifndef TOP
`define TOP
import uvm_pkg ::* ;
import hbus_pkg::*;
`include "uvm_macros.svh"
`include "yapp_if.sv"
`include "../hbus/sv/hbus_if.sv"
`include "../channel/sv/channel_if.sv"
`include "yapp.svh"
`include "yapp_router.sv"
`include "yapp_seq_lib.sv"
`include "router_vtest_lib.sv" 

module top();
     
  bit reset, clock ;

 // Instances of the channel interface and the hbus interface
  channel_if c_vif0(clock,reset);
  channel_if c_vif1(clock,reset);
  channel_if c_vif2(clock,reset);
  hbus_if    h_vif (clock,reset);


// Instances of the yapp interface and reset and the clock declartions 
  
  yapp_if in0 (clock, reset); 
  
  yapp_router dut (
                      .clock(in0.clock),                           
                      .reset(in0.reset),                                                 
                      .in_data(in0.in_data),                           
                      .in_data_vld(in0.in_data_vld),                   
                      .in_suspend(in0.in_suspend),
                            
                  

                    // Output Channels
                    .data_0(c_vif0.data),         //Channel 0
                    .data_vld_0(c_vif0.data_vld), 
                    .suspend_0(c_vif0.suspend), 

                       // Output Channels
                    .data_1(c_vif1.data),         //Channel 1
                    .data_vld_1(c_vif1.data_vld), 
                    .suspend_1(c_vif1.suspend),

                    .data_2(c_vif2.data),        //Channel 2
                    .data_vld_2(c_vif2.data_vld), 
                    .suspend_2(c_vif2.suspend),

                    // Host Interface Signals
                     .haddr(h_vif.haddr),
                     .hdata(h_vif.hdata_w),
                     .hen(h_vif.hen),
                     .hwr_rd(h_vif.hwr_rd)

                    );    
 
  initial begin
    yapp_vif_config::set(null, "*","vif",in0);
    channel_vif_config :: set(null, "*","vif",c_vif0);
    channel_vif_config :: set(null, "*","vif",c_vif1);
    channel_vif_config :: set(null, "*","vif",c_vif2);
    hbus_vif_config    ::set(null, "*","vif",h_vif); 
    run_test("simple_test");
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


  //Generate Clock
  always
    #5 clock = ~clock;


endmodule  

`endif
