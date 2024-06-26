//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_agent.sv
// version   :0.1 
//  ------------yapp_tx_agent.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_AGENT
`define YAPP_TX_AGENT

 
  class yapp_tx_agent extends uvm_agent;
   
    `uvm_component_utils(yapp_tx_agent);

    yapp_tx_monitor monitor;
   
    yapp_tx_driver driver;

    yapp_tx_sequencer sequencer;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      monitor = yapp_tx_monitor:: type_id:: create("monitor",this);
      if(get_is_active()) begin
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
 
  endclass  






`endif  // YAPP_TX_AGENT
