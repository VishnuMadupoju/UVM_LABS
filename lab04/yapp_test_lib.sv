///////////////////////////////////////////////////////////////////////////////
// File Name : yapp_test_lib.sv
// version   :0.1
//--------------yapp_test_lib--------------------
//////////////////////////////////////////////////////////////////////////////



`ifndef BASE_TEST
`define BASE_TEST 
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  class base_test extends uvm_test;

    `uvm_component_utils(base_test);

    function new(string name , uvm_component parent =null);
      super.new(name, parent);
    endfunction 

    yapp_env env;

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = yapp_env :: type_id :: create ("env", this);
      uvm_config_wrapper::set(this, "env.agent.sequencer.run_phase","default_sequence",yapp_tx_seqs::type_id::get());    
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();

    endfunction 

  endclass

  class short_packet_test extends base_test;
   
    `uvm_component_utils(short_packet_test);

    function new(string name , uvm_component parent =null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
    endfunction
 
  
  endclass

  class set_config_test extends base_test;

     `uvm_component_utils(set_config_test);

     function new(string name , uvm_component parent =null);
       super.new(name, parent);
     endfunction
     function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       set_config_int("env.agent","is_active",UVM_PASSIVE); 
     endfunction

   
  endclass

`endif// BASE_TEST
