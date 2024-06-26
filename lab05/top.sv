///////////////////////////////////////////////////////////////////////////////////////////
// File Name : top.sv
// Version   : 0.1
//-------------------top.dv-------------------------------------------------------------
//
//////////////////////////////////////////////////////////////////////////////////////////

`ifndef TOP
`define TOP
  `include "uvm_macros.svh"
  `include "yapp.svh"
  `include  "yapp_seq_lib.sv"
  `include  "yapp_test_lib.sv"
  import uvm_pkg ::* ;
  module top();
    //base_test test;
    initial begin
      //test = base_test::type_id::create("test",null);
      run_test();
    end

  endmodule  

`endif
