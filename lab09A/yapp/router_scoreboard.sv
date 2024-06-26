////////////////////////////////////////////////////////////////////////////////////////////////////
//  File Name : router_scoreboard.sv
//  Version   : 0.1
//----------------------------router_scoreboard.sv-------------------------------------------------
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef ROUTER_SCOREBOARD
`define ROUTER_SCOREBOARD

class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard);
 
//Declaring the necessory declaration to differentiate the diffrent analysis import ports 
 
  `uvm_analysis_imp_decl(_yapp_imp);
  `uvm_analysis_imp_decl(_ch0_imp);
  `uvm_analysis_imp_decl(_ch1_imp);
  `uvm_analysis_imp_decl(_ch2_imp);

// Declaring the queues and yapp packet handlers to record the  trasction values from the monitors

  yapp_packet  queue_00[$]; 
  yapp_packet  queue_01[$]; 
  yapp_packet  queue_10[$]; 

//Declaring the counter to report the pkts that recieved , wrong pkts, and mached packets
  
  static int  no_of_packets_recieved, wrong_pkts , mached_pkts; 
   

// Differentation  between the  different declartions

  uvm_analysis_imp_yapp_imp #(yapp_packet,router_scoreboard)analysis_yapp_imp;  
  uvm_analysis_imp_ch0_imp #(yapp_packet,router_scoreboard) analysis_ch0_imp;  
  uvm_analysis_imp_ch1_imp #(yapp_packet,router_scoreboard) analysis_ch1_imp;  
  uvm_analysis_imp_ch2_imp #(yapp_packet,router_scoreboard) analysis_ch2_imp;

// constructer function to construct the objects for the analysis ports 

  function new(string name, uvm_component parent);
    super.new(name,parent);
    analysis_yapp_imp = new("analysis_yapp_imp",this);
    analysis_ch0_imp = new("analysis_ch0_imp", this);
    analysis_ch1_imp = new("analysis_ch1_imp", this);
    analysis_ch2_imp = new("analysis_ch2_imp", this);
  endfunction :new 


// write function to get the written data from the monitors  
  extern virtual function void write_yapp_imp (yapp_packet pkt);
  extern virtual function void write_ch0_imp (yapp_packet pkt);
  extern virtual function void write_ch1_imp (yapp_packet pkt);
  extern virtual function void write_ch2_imp (yapp_packet pkt);
  extern virtual function void report_phase(uvm_phase phase);
endclass :router_scoreboard

// Write method to get the data from the yapp monitor and do the necessory operations

  function void router_scoreboard ::write_yapp_imp(yapp_packet pkt);
    yapp_packet pkt_cl;
    $cast(pkt_cl, pkt.clone());
    if(pkt.addr == 2'b00) begin
       queue_00.push_front(pkt);
       no_of_packets_recieved ++;
    end
    else if(pkt.addr == 2'b01) begin 
      queue_01.push_front(pkt);
      no_of_packets_recieved ++;
    end
    else begin
      queue_10.push_front(pkt);
      no_of_packets_recieved ++;
    end
  endfunction



// Write method to get the data from the channel monitor 0 and do the necessory operations
  function void router_scoreboard ::write_ch0_imp(yapp_packet pkt);
    if( queue_00.pop_back().compare(pkt)) begin
      `uvm_info("SCO_CH0","succesfull without packet  drops",UVM_NONE);
      mached_pkts++;
    end
    else begin
      `uvm_info("SCO_CH0",$sformatf("Failed  witho  packet  drops drops",pkt.sprint()),UVM_NONE);
      wrong_pkts ++;
    end
  endfunction


// Write method to get the data from the channel monitor 1 and do the necessory operations
  function void router_scoreboard ::write_ch1_imp(yapp_packet pkt);
    if( queue_01.pop_back().compare(pkt)) begin
      `uvm_info("SCO_CH0","succesfull without packet  drops",UVM_NONE);
      mached_pkts++;
    end
    else begin
      `uvm_info("SCO_CH0",$sformatf("Failed  witho  packet  drops drops",pkt.sprint()),UVM_NONE);
      wrong_pkts ++;
    end
  endfunction

// Write method to get the data from the channel monitor 2 and do the necessory operations
  function void router_scoreboard ::write_ch2_imp(yapp_packet pkt);
    if( queue_10.pop_back().compare(pkt)) begin
      `uvm_info("SCO_CH0","succesfull without packet  drops",UVM_NONE);
     mached_pkts++;
    end
    else begin
      `uvm_info("SCO_CH0",$sformatf("Failed  witho  packet  drops drops",pkt.sprint()),UVM_NONE);       
       wrong_pkts ++;
    end
  endfunction

//uvm report_phase to the number of recieved and mached and miss mached packets or left over packets in the queues

  function void  router_scoreboard ::report_phase(uvm_phase phase);
    `uvm_info("SCO_END",$sformatf("No_of_packets =%0d , No_of_mached =%0d , No_of_wrong =%0d and leftovers_Q1 =%0d,leftovers_Q2 =%0d,leftovers_Q3 =%0d", no_of_packets_recieved,mached_pkts, wrong_pkts,queue_00.size(),queue_01.size(),queue_10.size()),UVM_NONE);
  endfunction

   


`endif 
