`include "uvm_macros.svh"
import uvm_pkg :: *;


//-----------packet/sequence item class-----------------------------


class packet extends uvm_sequence_item;
  
  randc bit [7:0]  	source_add, dest_add;
  randc bit [15:0] 	data;

  `uvm_object_utils_begin(packet)
  `uvm_field_int (source_add, UVM_DEFAULT)
  `uvm_field_int (dest_add, UVM_DEFAULT)
  `uvm_field_int (data, UVM_DEFAULT)  	
  `uvm_object_utils_end

  function new(string name = "packet");
    super.new(name);
  endfunction
endclass    


//-----------sequencer class---------------------------------


class packet_sequencer extends uvm_sequencer #(packet);
  
  `uvm_object_utils(packet_sequencer)

  function new(string name="packet_sequencer", uvm_component parent=null);
    super.new(name,parent);
  endfunction
endclass    


//-----------Sequence class-----------------------------


class packet_sequence extends uvm_sequence #(packet);
  
  packet pkt;

  `uvm_object_utils(packet_sequence)

  function new(string name = "packet_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(3) begin
      `uvm_do(pkt);     
    end
  endtask
  
endclass


//-----------driver class-----------------------------


class driver extends uvm_driver #(packet);      
  
  `uvm_component_utils(driver)
  packet pkt;

  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual task run();
    `uvm_info("Driver", "Received Data", UVM_MEDIUM)
    forever 
      begin       
        seq_item_port.get_next_item(pkt);
        pkt.print();
        seq_item_port.item_done();
      end
  endtask
endclass    


//-----------Environment class-----------------------------


class environment extends uvm_env;
  
  `uvm_component_utils(environment)
  
  packet pkt;
  packet_sequencer pkt_seqr;
  driver drv;

  function new(string name="environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build();
    super.build();
    pkt_seqr = packet_sequencer::type_id::create("pkt_seqr",this);
    drv = driver::type_id::create("drv",this);
  endfunction

  virtual function void connect();
    drv.seq_item_port.connect(pkt_seqr.seq_item_export);
  endfunction
  
endclass
    

//-----------Test class-----------------------------


class test extends uvm_test;
  
  environment env;
  packet pkt;
  packet_sequence pkt_seq;


  `uvm_component_utils(test)

  function new(string name = "test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build();
    super.build();
    env = environment::type_id::create("env",this);
    pkt_seq = packet_sequence::type_id::create("pkt_seq");
  endfunction


  virtual task run();
    phase_started(uvm_run_phase::get());  
    pkt_seq.start(env.pkt_seqr);
    phase_ended(uvm_run_phase::get());
  endtask
  
endclass

//-----------TestBench----------------------------

module tb;
  initial 
    begin
      run_test("test");
    end
endmodule
