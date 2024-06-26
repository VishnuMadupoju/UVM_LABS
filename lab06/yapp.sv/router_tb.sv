////////////////////////////////////////////////////////////////////////
// File Name :router_tb.sv
// Version   :0.1
//---------------------router_tb.sv-------------------------------
//////////////////////////////////////////////////////////////////////

`ifndef ROUTER_TB
`define ROUTER_TB

  class router_tb extends uvm_component;
    `uvm_component_utils(router_tb);
    yapp_env env;
 
    function new(string name , uvm_component parent =null);
      super.new(name,parent);
    endfunction

    extern function void build_phase(uvm_phase phase); 

  endclass

    function void router_tb:: build_phase(uvm_phase phase);
      set_config_int( "*", "recording_detail", 1);
      super.build_phase(phase);
      env= yapp_env::type_id::create("env",this);
    endfunction

`endif // ROUTER_TB
