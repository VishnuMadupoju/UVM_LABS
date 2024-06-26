////////////////////////////////////////////////////////////
// File name : router_virtual_sequencer.sv
// version   : 0.1
// ---------------- router_virtual_sequencer.sv---------
////////////////////////////////////////////////////////////

`ifndef VIRTUAL_SEQUENCER
`define VIRTUAL_SEQUENCER
  

class router_virtual_sequencer extends uvm_sequencer #(yapp_packet);
  `uvm_component_utils(router_virtual_sequencer);

  function new(string name , uvm_component parent = null);
    super.new( name,parent);
  endfunction 

// Handlers of the yapp  and hbus sequencer

  yapp_tx_sequencer yapp_sequencer;

  hbus_master_sequencer hbus_sequencer;

endclass : router_virtual_sequencer

`endif // VIRTUAL_SEQUENCER




