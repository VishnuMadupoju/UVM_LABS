/////////////////////////////////////////////////////////////////////////////////////////////////
//
//File name : router_virtual_seqs.sv
//Version   : 0.1
//-------------------- router_seqs.sv---------------------------------------
// 
////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef VIRTUAL_SEQUENCE
`define VIRTUAL_SEQUENCE
  

class router_simple_vseq extends uvm_sequence #(yapp_packet);
  
  `uvm_object_utils(router_simple_vseq);
  
  `uvm_declare_p_sequencer(router_virtual_sequencer);

  function new(string name ="router_simple_vseq");
    super.new( name);
  endfunction :new 


// Applying all the virtual sequences that are necessory for the router to work
  hbus_small_packet_seq      small_packet;
  hbus_read_max_pkt_seq      read_max_size;
  yapp_012_seq               yapp_012_seq_1;
  hbus_set_default_regs_seq  max_packet;
  hbus_read_max_pkt_seq      read_max_packet;
  yapp_tx_seqs               random_sequences;

// Declaring the functions and tasks to be extern
  extern virtual  task pre_body();
  extern virtual  task body ();

endclass : router_simple_vseq 

//UVM sequence Prebody

  task router_simple_vseq  :: pre_body();
    small_packet     = hbus_small_packet_seq :: type_id ::create("small_packet");
    read_max_size    = hbus_read_max_pkt_seq   :: type_id ::create("read_max_size");
    yapp_012_seq_1   = yapp_012_seq   :: type_id ::create("yapp_012_seq_1");
    max_packet       = hbus_set_default_regs_seq  :: type_id ::create(" max_packet");
    read_max_packet  = hbus_read_max_pkt_seq :: type_id ::create("read_max_packet");
    random_sequences =  yapp_tx_seqs   :: type_id ::create("random_sequences");
  endtask

// UVM sequence body

  task  router_simple_vseq ::body();
    if(starting_phase != null) starting_phase.raise_objection(this);
      small_packet.start(p_sequencer.hbus_sequencer);
      read_max_size .start(p_sequencer.hbus_sequencer);
      for(int i=0 ;i< 6;i++)
      begin
          yapp_012_seq_1.start(p_sequencer.yapp_sequencer);  
      end
      max_packet.start(p_sequencer.hbus_sequencer);
      read_max_packet.start(p_sequencer.hbus_sequencer);
      random_sequences.start(p_sequencer.yapp_sequencer);
    if(starting_phase != null) starting_phase.drop_objection(this);
  endtask
    

`endif // VIRTUAL_SEQUENCE









