/*-----------------------------------------------------------------
File name     : test_lib.sv
Description   :
Notes         :
-------------------------------------------------------------------
-----------------------------------------------------------------*/

`include "demo_tb.sv"

//----------------------------------------------------------------
//
// TEST: demo_base_test - Base test
//
//----------------------------------------------------------------
class demo_base_test extends uvm_test;

  `uvm_component_utils(demo_base_test)

  demo_tb tb;

  function new(string name = "demo_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    set_config_int("*", "recording_detail", UVM_FULL);
    // Create the tb
    tb = demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

endclass : demo_base_test

//----------------------------------------------------------------
// TEST: hbus_write_read_test
//----------------------------------------------------------------
class hbus_write_read_test extends demo_base_test;

  `uvm_component_utils(hbus_write_read_test)

  function new(string name = "hbus_write_read_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // Set the default sequence for the master and slave
    uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.main_phase",
                            "default_sequence",
                            hbus_set_get_regs_seq::type_id::get());

    uvm_config_wrapper::set(this, "tb.hbus.slaves[0].sequencer.main_phase",
                            "default_sequence",
                            hbus_slave_response_seq::type_id::get());
    // Create the tb
    super.build_phase(phase);
  endfunction : build_phase

endclass : hbus_write_read_test
