//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_agent.sv
// version   :0.1 
//  ------------yapp_tx_agent.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_AGENT
`define YAPP_TX_AGENT
  `include "uvm_macros.svh"
   import uvm_pkg::*;
 
  class yapp_tx_agent extends uvm_agent;
   
    `uvm_component_utils(yapp_tx_agent);

    yapp_tx_monitor monitor;
   
    yapp_tx_driver driver;

    yapp_tx_sequencer sequencer;
    
    yapp_tx_seqs sequence_1;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      monitor = yapp_tx_monitor:: type_id:: create("monitor",this);
      if(get_is_active()) begin
        sequence_1 = yapp_tx_seqs  :: type_id :: create("sequence_1");
        sequencer = yapp_tx_sequencer:: type_id:: create("sequencer",this);
	driver    = yapp_tx_driver:: type_id:: create("driver",this);
      end

    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(get_is_active()) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
      end
    endfunction 
    
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("AGENT",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction 
     
     
     
  endclass  





`endif  // YAPP_TX_AGENT


