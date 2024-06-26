////////////////////////////////////////////////////////////////////////////////////////////////
// File Name : yapp_tx_seqs.sv
// version   : 0.1
// -------------yapp_tx_seqs---------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////



`ifndef YAPP_TX_SEQS
`define YAPP_TX_SEQS


`include "uvm_macros.svh"
  import uvm_pkg::*;
  class yapp_tx_seqs extends uvm_sequence#(yapp_packet);

  `uvm_object_utils(yapp_tx_seqs);
   
  function new (string name = "yapp_seqs");
    super.new(name);  
  endfunction 
  
  task body();
    for (int i=0;i<5 ;i++)
    begin
     `uvm_do(req);
    end
   endtask 

endclass


`endif //YAPP_TX_SEQS

