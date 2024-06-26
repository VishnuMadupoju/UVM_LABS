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
  
   // Declare this property to count packets sent
    int num_sent;

    virtual yapp_if vif;

   
    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction
   
    extern virtual function void build_phase(uvm_phase phase);    
    extern virtual function void report_phase(uvm_phase phase);    
    extern virtual function void start_of_simulation_phase(uvm_phase phase);    
    extern task run_phase(uvm_phase phase);    
    extern task send_to_dut(yapp_packet packet);    
    extern task get_and_drive();
    extern task reset_signals(); 
  endclass  

    
//UVM build_phase() 
     
    function void yapp_tx_driver ::build_phase(uvm_phase phase);
      if (!yapp_vif_config::get(this,"","vif", vif))
         `uvm_fatal("NOVIF",{"vif not set for: ",get_full_name(),".vif"}); 
    endfunction :build_phase



// Sent to DUT task
    task yapp_tx_driver :: send_to_dut(yapp_packet packet);
      // Wait for packet delay
      repeat(packet.packet_delay)
        @(negedge vif.clock);

      // Start to send packet if not in_suspend signal

        @(negedge vif.clock iff (!vif.in_suspend));
      // Begin Transaction recording
      void'(this.begin_tr(packet, "Input_YAPP_Packet"));

      // Enable start packet signal
      vif.in_data_vld <= 1'b1;

      // Drive the Header {Length, Addr}
      vif.in_data <= { packet.length, packet.addr };

      // Drive Payload
      for (int i=0; i<packet.payload.size(); i++) begin
        @(negedge vif.clock iff (!vif.in_suspend))
        vif.in_data <= packet.payload[i];
      end
      // Drive Parity and reset Valid
      @(negedge vif.clock iff (!vif.in_suspend))
      vif.in_data_vld <= 1'b0;
      vif.in_data  <= packet.parity;

      @(negedge  vif.clock)
        vif.in_data  <= 8'bz;
      num_sent++;

      // End transaction recording
      this.end_tr(packet);

 
    endtask:send_to_dut

  // UVM run_phase
     task yapp_tx_driver ::run_phase(uvm_phase phase);
       fork
         get_and_drive();
         reset_signals();
        join
     endtask : run_phase


 // Gets packets from the sequencer and passes them to the driver. 
  task yapp_tx_driver :: get_and_drive();
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever begin
      seq_item_port.get_next_item(req);
     $display("--------------AAAAAAAAAAAAAAAAAAAAAAAAAAA------------");
      req.print();
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask : get_and_drive



// Reset all TX signals

  task yapp_tx_driver :: reset_signals();
      forever begin
        @(posedge vif.reset);
         `uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM)
        vif.in_data           <=  'hz;
        vif.in_data_vld       <= 1'b0;
        disable send_to_dut;
      end
  endtask : reset_signals


 // UVM start_of_simulation_phase

  function void yapp_tx_driver ::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("DRIVER",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
  endfunction 

 // UVM report_phase() 
  function void yapp_tx_driver :: report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
  endfunction : report_phase


`endif  // YAPP_TX_DRIVER
 
