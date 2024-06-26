//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_sequencer.sv
// version   :0.1 
//  ------------yapp_tx_sequencer.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_SEQUENCER
`define YAPP_TX_SEQUENCER


 
  class yapp_tx_sequencer extends uvm_sequencer#(yapp_packet);
   
    `uvm_component_utils(yapp_tx_sequencer);
   
     function new(string name ,uvm_component parent =null);
       super.new(name,parent);
     endfunction
   
  endclass  




`endif  // YAPP_TX_SEQUENCER
