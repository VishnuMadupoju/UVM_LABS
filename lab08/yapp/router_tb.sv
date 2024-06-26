////////////////////////////////////////////////////////////////////////
// File Name :router_tb.sv
// Version   :0.1
//---------------------router_tb.sv-------------------------------
//////////////////////////////////////////////////////////////////////

`ifndef ROUTER_TB
`define ROUTER_TB

class router_tb extends uvm_component;
  `uvm_component_utils(router_tb);

// Handlers for the various instances
  yapp_env env;
  router_simple_vseq  v_sequences;
  router_virtual_sequencer v_sequencer;

// Channel Bus handlers 
  channel_env ch_0;
  channel_env ch_1;
  channel_env ch_2;
// HBUS handlers 
  hbus_env  h_env;
    

  function new(string name , uvm_component parent =null);
    super.new(name,parent);
  endfunction

// Declaring the functions as the extern 
  extern function void build_phase(uvm_phase phase); 
  extern function void connect_phase(uvm_phase phase); 
endclass :router_tb 

// UVM build_phase
  function void router_tb:: build_phase(uvm_phase phase);
    set_config_int( "*", "recording_detail", 1);
    set_config_int( "*", "has_tx", 0);
    set_config_int( "*", "num_masters", 1);
    set_config_int( "*", "num_slaves", 0);
    super.build_phase(phase);
    env         = yapp_env::type_id::create("env",this);
    ch_0        = channel_env ::type_id ::create("ch_0",this);
    ch_1        = channel_env ::type_id ::create("ch_1",this);
    ch_2        = channel_env ::type_id ::create("ch_2",this);
    h_env       = hbus_env ::type_id::create("h_env",this);
    v_sequences = router_simple_vseq ::type_id::create(" v_sequences ",this);
    v_sequencer = router_virtual_sequencer ::type_id::create("v_sequencer ",this); 
  endfunction :build_phase  

// UVM connect_phase

  function void  router_tb ::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    v_sequencer.yapp_sequencer  = env.agent.sequencer;
    v_sequencer.hbus_sequencer  = h_env.masters[0].sequencer;
  endfunction :connect_phase


`endif // ROUTER_TB
