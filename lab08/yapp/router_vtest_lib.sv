////////////////////////////////////////////////////////////////////////////////////////////
//
//   File Name : router_vtest_lib.sv
//   Version   :0.1
//------------------router_vtest_lib.sv---------------------------------------------------
//
/////////////////////////////////////////////////////////////////////////////////////////////



`ifndef BASE_VTEST
`define BASE_VTEST 


// class base_test 

  class base_test extends uvm_test;

    `uvm_component_utils(base_test);

    function new(string name , uvm_component parent =null);
      super.new(name, parent);
    endfunction 

    router_tb rout_tb;

//  Declearing them as the external function or tasks

    extern function void  build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
 

  endclass :base_test

//UVM build_phase of class base_test
  
    function void base_test ::build_phase(uvm_phase phase);
      super.build_phase(phase);
      rout_tb = router_tb :: type_id :: create ("rout_tb", this);
    endfunction :build_phase

//UVM end_of_elaboration_phase of class base_test
  
    function void base_test ::end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
    endfunction :end_of_elaboration_phase

//UVM run_phase of class base_test

    task base_test :: run_phase(uvm_phase phase); 
      phase.phase_done.set_drain_time(this, 200ns); 
    endtask :run_phase


//clss short_packet_test

  class short_packet_test extends base_test;
   
    `uvm_component_utils(short_packet_test);

    function new(string name , uvm_component parent =null);
      super.new(name, parent);
    endfunction
      
    extern function void build_phase(uvm_phase phase);

  endclass :short_packet_test

 //UVM reun_phase of class short_packet to override

    function void short_packet_test::build_phase(uvm_phase phase);
      super.build_phase(phase);
      set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
    endfunction :build_phase


//class set_config_test

  class set_config_test extends base_test;
    
    `uvm_component_utils(set_config_test);

    function new(string name , uvm_component parent =null);
      super.new(name, parent);
    endfunction

    extern function void build_phase (uvm_phase phase); 
  
  endclass :set_config_test
   
//UVM build_phase of class set_config_test
 
    function void set_config_test::build_phase(uvm_phase phase);
      super.build_phase(phase);
      set_config_int("rout_tb.env.agent","is_active",UVM_PASSIVE); 
    endfunction :build_phase
  
//UVM short_incr_payload

  class short_incr_payload extends base_test;
    
     `uvm_component_utils(short_incr_payload);

     function new(string name , uvm_component parent =null);
       super.new(name, parent);
     endfunction
  
     extern function void build_phase(uvm_phase phase);
  endclass :short_incr_payload

//UVM short_incr_payload build_phase

     function void short_incr_payload:: build_phase(uvm_phase phase);
       super.build_phase(phase);
       uvm_config_wrapper::set(this, "rout_tb.env.agent.sequencer.run_phase","default_sequence",yapp_incr_payload_seq::type_id::get());    
       set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
     endfunction :build_phase


// To pass the values from the exhaustive test

  class exhaustive_seq_lib extends base_test;
    
    `uvm_component_utils(exhaustive_seq_lib);
    yapp_seq_lib  seq_lib;

    function new(string name , uvm_component parent =null);
       super.new(name, parent);
      seq_lib = yapp_seq_lib ::type_id::create("seq_lib");   
    endfunction 

    extern  function void build_phase(uvm_phase phase);
    extern  function void end_of_elaboration_phase(uvm_phase phase);

  endclass :exhaustive_seq_lib

//UVM exhaustive_seq_lib build_phase

    function void exhaustive_seq_lib::build_phase(uvm_phase phase);
      super.build_phase(phase);
      seq_lib.selection_mode   = UVM_SEQ_LIB_RANDC;
      seq_lib.min_random_count = 5;
      seq_lib.max_random_count = 10;
      void'(seq_lib.randomize);
      uvm_config_db#(uvm_sequence_base)::set(this, "rout_tb.env.agent.sequencer.run_phase","default_sequence",seq_lib);    
      set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
    endfunction :build_phase

//UVM exhaustive_seq_lib build_phase

    function void exhaustive_seq_lib:: end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      seq_lib.print();
    endfunction:end_of_elaboration_phase  
	
//UVM simple_test 

  class simple_test extends base_test;

    `uvm_component_utils(simple_test);
   
    function new(string name ,uvm_component parent =null );
      super.new(name ,parent);
    endfunction
    
    extern function void build_phase(uvm_phase phase);

  endclass :simple_test
    
//UVM build_phase


    function void simple_test::build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_wrapper::set(this, "rout_tb.env.agent.sequencer.run_phase","default_sequence",yapp_012_seq ::type_id::get());    
      uvm_config_wrapper::set(this, "rout_tb.ch_0.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());    
      uvm_config_wrapper::set(this, "rout_tb.ch_1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq ::type_id::get());    
      uvm_config_wrapper::set(this, "rout_tb.ch_2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());    
      set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
    endfunction :build_phase	 

//class simple_extends the inorder to fallow the methods to v test 


  class  router_vtest_lib extends base_test;

    `uvm_component_utils(simple_test);
   
    function new(string name ,uvm_component parent =null );
      super.new(name ,parent);
    endfunction
    
    extern function void build_phase(uvm_phase phase);

  endclass :router_vtest_lib


   //UVM build_phase

    function void router_vtest_lib ::build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_wrapper::set(this, "rout_tb.ch_0.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());    
      uvm_config_wrapper::set(this, "rout_tb.ch_1.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq ::type_id::get());    
      uvm_config_wrapper::set(this, "rout_tb.ch_2.rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::type_id::get());    
      set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
      uvm_config_wrapper::set(this, "rout_tb.v_sequencer.run_phase","default_sequence",router_simple_vseq::type_id::get());    
    endfunction :build_phase	 


  
 

`endif// BASE_VTEST
