//////////////////////////////////////////////////////////////////////
//
// File Name :yapp_env.sv
// version   :0.1 
//  ------------yapp_env.sv-----------------
///////////////////////////////////////////////////////////////////////


    
`ifndef YAPP_ENV
`define YAPP_ENV

 
  class yapp_env extends uvm_env;
   
    `uvm_component_utils(yapp_env);

    yapp_tx_agent agent;


    function new(string name ,uvm_component parent =null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase (phase);
      agent = yapp_tx_agent:: type_id:: create("agent",this);

    endfunction

    virtual task run_phase(uvm_phase phase);
      print();

    endtask
     
   
  endclass  

`endif  // YAPP_ENV
