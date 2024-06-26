/////////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_driver.sv
// version   :0.1 
// ------------yapp_tx_driver.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_DRIVER
`define YAPP_TX_DRIVER
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  class yapp_tx_driver extends uvm_driver#(yapp_packet);
   
    `uvm_component_utils(yapp_tx_driver);

   
     function new(string name ,uvm_component parent =null);
       super.new(name,parent);
     endfunction
   
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("DRIVER",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
    endfunction 
    
    virtual task run_phase(uvm_phase phase);
  
    forever begin
      seq_item_port.get_next_item(req);

      send_to_dut(req);

      seq_item_port.item_done();
    end
   
    endtask

    task send_to_dut(yapp_packet pkt);
       `uvm_info("yapp_tx_driver",$sformatf("Packet is \n",pkt.sprint()),UVM_LOW);   
    endtask
 
  endclass  






`endif  // YAPP_TX_DRIVER
 
