//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_monitor.sv
// version   :0.1 
//  ------------yapp_tx_monitor.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_MONITOR
`define YAPP_TX_MONITOR

  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  class yapp_tx_monitor extends uvm_monitor;
   
    `uvm_component_utils(yapp_tx_monitor);
   
     function new(string name ,uvm_component parent =null);
       super.new(name,parent);
     endfunction

    virtual task run_phase(uvm_phase phase);

      `uvm_info("MONITOR","In the Monitor", UVM_NONE);

    endtask   
 
  endclass  






`endif  // YAPP_TX_MONITOR
