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
  import uvm_pkg ::* ;
  module top();
    yapp_env env ;
    initial begin 
      env = yapp_env :: type_id :: create ("env",null);
    end
    
    initial begin
      run_test();
    end

  endmodule  

`endif
