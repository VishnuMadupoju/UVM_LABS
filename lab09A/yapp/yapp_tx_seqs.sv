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
 
// Declaring the tasks and functions as extern
 
  extern virtual task body();

endclass :yapp_tx_seqs



//uvm_body of the yapp_tx_seqs

  task yapp_tx_seqs :: body();
    for (int i=0;i<5 ;i++)
    begin
     `uvm_do(req);
    end
  endtask: body 


// class yapp_012_seq of the incr addr sequences

class yapp_012_seq extends yapp_tx_seqs;

  `uvm_object_utils(yapp_012_seq);
   
  function new (string name = "yapp_012_seq");
    super.new(name);  
  endfunction 
 
  extern virtual task body (); 
    
endclass :yapp_012_seq


//uvm_body of the yapp_tx_seqs

   task yapp_012_seq ::body();
    if(starting_phase != null) starting_phase.raise_objection(this);
    for (int i=0;i<3 ;i++)
    begin
      `uvm_do_with(req,{req.addr==0+i;
                      }
                  );
    end
    if(starting_phase != null) starting_phase.drop_objection(this);
  endtask :body
 
 
// Class yapp_1_seq for the  addr to 1


class yapp_1_seq extends yapp_tx_seqs;

  `uvm_object_utils(yapp_1_seq);
   
  function new (string name = "yapp_1_seq");
    super.new(name);  
  endfunction 
  
  extern virtual task body();
    
endclass :yapp_1_seq 

// Body of the yapp_1_seq so as to get the number addr to 1

  task yapp_1_seq :: body();
    `uvm_do_with(req,{req.addr== 1;
                     }
                );
  endtask : body


// yapp_111_seq to call the sequences of the seq_1 to 3 times

class yapp_111_seq extends yapp_tx_seqs;

  `uvm_object_utils(yapp_111_seq);

  yapp_1_seq seq_1;
   
  function new (string name = "yapp_111_seq");
    super.new(name);  
  endfunction 
  
  extern virtual task body(); 
        
endclass :yapp_111_seq 

//uvm_body for the yapp_111_seq  

  task  yapp_111_seq :: body();
    seq_1  = yapp_1_seq::type_id::create("seq_1");
    `uvm_do(seq_1);
    `uvm_do(seq_1);
    `uvm_do(seq_1);
  endtask :body


// yapp_repeat_addr sequences 

class yapp_repeat_addr_seq extends yapp_tx_seqs;

  `uvm_object_utils(yapp_repeat_addr_seq);
  
  local bit  [1:0] prev_addr ;
  
  function new (string name = "yapp_repeat_addr_seq");
    super.new(name);  
  endfunction 
  
  extern task body();
     
endclass :yapp_repeat_addr_seq

// Reapeat address sequences body

  task yapp_repeat_addr_seq :: body();
    `uvm_do(req);  
    prev_addr=req.addr;
    `uvm_do_with(req, {req.addr==prev_addr;
                      }
                )
  endtask :body

// yapp_incr_payload_seq for to get the sequence of payload length in the inc order 

class yapp_incr_payload_seq extends yapp_tx_seqs;

  `uvm_object_utils(yapp_incr_payload_seq);
  
  function new (string name = "yapp_incr__payload_seq");
    super.new(name);  
  endfunction 
  
  extern virtual task body (); 
     
endclass :yapp_incr_payload_seq

// body task for the yapp_incr_payload_sequence

  task yapp_incr_payload_seq ::body();
    `uvm_create(req);
    assert(req.randomize());
    for(int i=0 ;i <req.length-1;i++)
    begin
      req.payload[i]= i;
    end
    `uvm_send(req);
  endtask :body


// yapp_rnd_seq sequence for to get the count to limit to 10;

class yapp_rnd_seq extends yapp_tx_seqs;

  `uvm_object_utils(yapp_rnd_seq);
  
  function new (string name = "yapp_rnd_seq");
    super.new(name);  
  endfunction 
  
  rand int count;
  
   
  extern  virtual task body();
  
  constraint limit_count {
                           count inside {[1:10]};
                         } 
endclass : yapp_rnd_seq



// Body of the sequence of yapp_rnd_seq

  task yapp_rnd_seq ::body();
    randomize();
    repeat(count)
      `uvm_do(req);
  endtask:body



// six_yapp_seq to generate the six to limit the count to 6

class six_yapp_seq extends yapp_rnd_seq;

  `uvm_object_utils(six_yapp_seq);
  
  function new (string name = "six_yapp_seq");
    super.new(name);  
  endfunction 
     
  extern  virtual task body();  

  constraint limit_count_six {
                              count == 6;
                             } 
endclass:six_yapp_seq

// body of the sequence six_yapp_seq

  task six_yapp_seq ::body();
    randomize();
    repeat(count)
      `uvm_do(req);
  endtask :body


`endif //YAPP_TX_SEQS

