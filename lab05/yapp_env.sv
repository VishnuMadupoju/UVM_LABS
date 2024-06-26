//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_env.sv
// version   :0.1 
//  ------------yapp_env.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_ENV
`define YAPP_ENV
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  class yapp_env extends uvm_env;
   
    `uvm_component_utils(yapp_env);

    yapp_tx_agent agent;


    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      agent = yapp_tx_agent :: type_id:: create("agent",this);
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("ENV",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction
         
  endclass  

`endif  // YAPP_ENV
