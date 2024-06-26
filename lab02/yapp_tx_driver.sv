/////////////////////////////////////////////////////////////////////////
//
// File Name :yapp_tx_driver.sv
// version   :0.1 
// ------------yapp_tx_driver.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_TX_DRIVER
`define YAPP_TX_DRIVER
 
  class yapp_tx_driver extends uvm_driver#(yapp_packet);
   
    `uvm_component_utils(yapp_tx_driver);

    yapp_packet pkt;
   
     function new(string name ,uvm_component parent =null);
       super.new(name,parent);
     endfunction
    
    virtual task run_phase(uvm_phase phase);
  
    forever begin
      seq_item_port.get_next_item(pkt);

      send_to_dut(pkt);

      seq_item_port.item_done();
    end
   
    endtask

    task send_to_dut(yapp_packet pkt);
       `uvm_info("yapp_tx_driver",$sformatf("Packet is \n",pkt.sprint()),UVM_LOW);   
    endtask 
  endclass  






`endif  // YAPP_TX_DRIVER
 
