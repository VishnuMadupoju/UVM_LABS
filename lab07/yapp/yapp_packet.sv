///////////////////////////////////////////////////////////
// File Name : yapp_packet.sv
// version   :0.1
//  -----yapp_packet-----------
////////////////////////////////////////////////////////////

  
`ifndef YAPP_PACKET
`define YAPP_PACKET
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  typedef enum {GOOD_PARITY,BAD_PARITY} parity_t;

  class yapp_packet extends uvm_sequence_item;
    
    function new(string name ="yapp_router");
      super.new(name);
    endfunction

    rand bit [5:0] length;
    rand bit [1:0] addr;
    rand bit [7:0] payload [];   
         bit [7:0] parity;
    rand parity_t  parity_type;
    rand int       packet_delay;



   `uvm_object_utils_begin(yapp_packet)
      `uvm_field_int(addr,UVM_ALL_ON|UVM_BIN)
      `uvm_field_int(length,UVM_ALL_ON|UVM_DEC)
      `uvm_field_array_int(payload,UVM_ALL_ON|UVM_BIN)     
      `uvm_field_int(parity,UVM_ALL_ON|UVM_BIN) 
      `uvm_field_enum(parity_t,parity_type,UVM_ALL_ON)
      `uvm_field_int(packet_delay,UVM_ALL_ON|UVM_DEC) 
    `uvm_object_utils_end



   function bit[7:0] calc_parity();
     bit [7:0] temp_parity;
     for(int i = 0; i<length; i++)
     begin
        if(i == 0)
          temp_parity = payload [0] ^{length,addr};
        else
          temp_parity = payload [i] ^ temp_parity;
     end
     return temp_parity;
   endfunction

   function void post_randomize();
      if(parity_type == GOOD_PARITY )
        parity = calc_parity();
      else
        parity ='h00; 
   endfunction



   constraint  vaild_transction { soft
                                  addr !=2'b11;
                                  length  != 'b0;                            
                                }

   constraint size_of_payload {
                                 payload.size == length;
                              } 


   constraint prob_good{ soft
                             parity_type dist {GOOD_PARITY := 5 , BAD_PARITY := 1};
                       }

   constraint range_packet_delay{
                                    packet_delay inside {[0:20]};
                                }


  endclass	

 class short_yapp_packet extends yapp_packet;

   `uvm_object_utils(short_yapp_packet);

   function new(string name ="yapp_short_packet");
      super.new(name);
    endfunction

   constraint limit_packet_length{ soft
                                    length < 15;  
                                 }


   constraint address_exclude {soft 
                                  addr !=2'b10;
                              }

 endclass
   
`endif //







