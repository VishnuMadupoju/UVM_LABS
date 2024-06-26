//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_sequencer.sv
// version   :0.1 
//  ------------yapp_tx_sequencer.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_SEQUENCER
`define YAPP_TX_SEQUENCER

`include "uvm_macros.svh"
import uvm_pkg::*;

class yapp_tx_sequencer extends uvm_sequencer#(yapp_packet);
 
  `uvm_component_utils(yapp_tx_sequencer);
 
   function new(string name ,uvm_component parent =null);
     super.new(name,parent);
   endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("SEQUENCER",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
  endfunction

endclass : yapp_tx_sequencer



`endif  // YAPP_TX_SEQUENCER
