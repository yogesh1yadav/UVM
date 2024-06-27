module hello_world;
  import uvm_pkg::*;
  initial begin
    uvm_report_info("TEST","hello world");                                                    //report is for display, displaying info , TEST is  ID for the message" hello world".
  end
endmodule



//to simulate in Aidec Riviera simulator
//in run options use this : +UVM_TESTNAME=hello_world 

`include "uvm_macros.svh";                                                                     // this macro contains definitions for various macros provided by the UVM library.
import uvm_pkg::*;

program automatic simple_test;                                                                 // keyword automatic ensures that variables are allocated dynamically on the stack
  class hello_world extends uvm_test;    
    `uvm_component_utils(hello_world);                                             //register the "hello_world" class with uvm factory.factory allows creation of uvm object & component dynamicaaly during simulation
   
    function new(string name, uvm_component parent);                                           //constructor for "hello_world" class, two argument : name(name of instance), parent(parent component)
      super.new(name, parent);                                                                 //invokes constructor of parent class
    endfunction

    virtual task run();                                                                        // predefined run() task in uvm
      `uvm_info("HELLO", "Hello World",UVM_NONE);                                              // ID, message string , verbosity level
    endtask

  endclass

  initial begin
    run_test();                                                                              //run_test() function is a UVM utility that kicks off the execution of the test.
  end

endprogram

/*OUTPUT:
# KERNEL: UVM_INFO /home/runner/testbench.sv(13) @ 0: uvm_test_top [HELLO] Hello World*/
