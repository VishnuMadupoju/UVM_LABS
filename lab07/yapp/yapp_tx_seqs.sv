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
    
   /* virtual task body();
      for (int i=0;i<5 ;i++)
      begin
       `uvm_do(req);
      end
      endtask */ 

  endclass
  
  class yapp_012_seq extends yapp_tx_seqs;

    `uvm_object_utils(yapp_012_seq);
     
    function new (string name = "yapp_012_seq");
      super.new(name);  
    endfunction 
    
    virtual task body();
      if(starting_phase != null) starting_phase.raise_objection(this);
      for (int i=0;i<3 ;i++)
      begin
        `uvm_do_with(req,{req.addr==0+i;
                        }
                    );
      end
       if(starting_phase != null) starting_phase.drop_objection(this);

    endtask
      
  endclass

  class yapp_1_seq extends yapp_tx_seqs;

    `uvm_object_utils(yapp_1_seq);
     
    function new (string name = "yapp_1_seq");
      super.new(name);  
    endfunction 
    
    virtual task body();
      `uvm_do_with(req,{req.addr== 1;
                       }
                  );
    endtask
      
  endclass

 
  class yapp_111_seq extends yapp_tx_seqs;

    `uvm_object_utils(yapp_111_seq);

     yapp_1_seq seq_1;
     
    function new (string name = "yapp_111_seq");
      super.new(name);  
    endfunction 
    
    virtual task body();
      seq_1  = yapp_1_seq::type_id::create("seq_1");
      `uvm_do(seq_1);
      `uvm_do(seq_1);
      `uvm_do(seq_1);
    endtask
       
  endclass


  class yapp_repeat_addr_seq extends yapp_tx_seqs;

    `uvm_object_utils(yapp_repeat_addr_seq);
    
    local bit  [1:0] prev_addr ;
    
    function new (string name = "yapp_repeat_addr_seq");
      super.new(name);  
    endfunction 
    
    virtual task body();
      `uvm_do(req);  
      prev_addr=req.addr;
      `uvm_do_with(req, {req.addr==prev_addr;
                        }
                  )
    endtask
       
  endclass

 class yapp_incr_payload_seq extends yapp_tx_seqs;

   `uvm_object_utils(yapp_incr_payload_seq);
   
   function new (string name = "yapp_incr__payload_seq");
     super.new(name);  
   endfunction 
   
   virtual task body();
     `uvm_create(req);
     assert(req.randomize());
     for(int i=0 ;i <req.length-1;i++)
     begin
        req.payload[i]= i;
     end
     `uvm_send(req);
   endtask
      
 endclass


 class yapp_rnd_seq extends yapp_tx_seqs;

   `uvm_object_utils(yapp_rnd_seq);
   
   function new (string name = "yapp_rnd_seq");
     super.new(name);  
   endfunction 
   
   rand int count;
   
   virtual task body();
     randomize();
     repeat(count)
       `uvm_do(req);
   endtask
  
  
   constraint limit_count {
                            count inside {[1:10]};
                          } 
 endclass


 class six_yapp_seq extends yapp_rnd_seq;

   `uvm_object_utils(six_yapp_seq);
   
   function new (string name = "six_yapp_seq");
     super.new(name);  
   endfunction 
      
   
   virtual task body();
     randomize();
     repeat(count)
       `uvm_do(req);
     
   endtask
  
   constraint limit_count_six {
                               count == 6;
                              } 
 endclass


 




`endif //YAPP_TX_SEQS

