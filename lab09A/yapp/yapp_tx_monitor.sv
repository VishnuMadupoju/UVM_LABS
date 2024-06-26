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
  
  virtual yapp_if vif;

// Count packets and responses collected
  int num_pkt_col;

// Collected Data handle
  yapp_packet packet_collected;

//UVM analysis port declartion with the handle

  uvm_analysis_port #(yapp_packet) collect_packet_m;


  function new(string name ,uvm_component parent =null);
    super.new(name,parent);
    collect_packet_m = new("collect_packet_m",this); 
  endfunction

// Declaring the function and tasks as the extern 

  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task collect_packet();

endclass  :yapp_tx_monitor

//UVM build_phase() 
     
  function void yapp_tx_monitor ::build_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this,"","vif", vif))
       `uvm_fatal("NOVIF",{"vif not set for: ",get_full_name(),".vif"});
  endfunction :build_phase


//UVM run_phase ()

  task yapp_tx_monitor ::run_phase(uvm_phase phase); 
    `uvm_info(get_type_name(), "Inside the run_phase", UVM_MEDIUM)
     // Create collected packet instance
     packet_collected = yapp_packet::type_id::create("packet_collected", this);
     // Look for packets after reset
     @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
     forever
       collect_packet();
  endtask:run_phase 


// collect_packet()


  task yapp_tx_monitor ::collect_packet();
     //Monitor looks at the bus on posedge (Driver uses negedge)
      @(posedge vif.in_data_vld);

      @(posedge vif.clock iff (!vif.in_suspend))

      // Begin transaction recording
      void'(this.begin_tr(packet_collected, "Monitor_YAPP_Packet"));

      `uvm_info(get_type_name(), "Collecting a packet", UVM_HIGH)
      // Collect Header {Length, Addr}
      { packet_collected.length, packet_collected.addr }  = vif.in_data;
      packet_collected.payload = new[packet_collected.length]; // Allocate the payload
      // Collect the Payload
      for (int i=0; i< packet_collected.length; i++) begin
         @(posedge vif.clock iff (!vif.in_suspend))
         packet_collected.payload[i] = vif.in_data;
      end

      // Collect Parity and Compute Parity Type
       @(posedge vif.clock iff !vif.in_suspend)
         packet_collected.parity = vif.in_data;
       packet_collected.parity_type = (packet_collected.parity == packet_collected.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      this.end_tr(packet_collected);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", packet_collected.sprint()), UVM_LOW)
      num_pkt_col++;
      collect_packet_m.write(packet_collected); 
  endtask:collect_packet


 // UVM report_phase
  function void yapp_tx_monitor :: report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase


//UVM start_of_simulation_phase()
  function void  yapp_tx_monitor ::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("MONITOR",$sformatf("In the component %0s",get_full_name()),UVM_HIGH);
  endfunction: start_of_simulation_phase




`endif  // YAPP_TX_MONITOR
