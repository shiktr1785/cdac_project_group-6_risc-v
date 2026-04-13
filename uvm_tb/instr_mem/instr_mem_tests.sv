`ifndef __INSTR_MEM_TESTS_SV
`define __INSTR_MEM_TESTS_SV

// Base test class
class instr_mem_base_test#(parameter BUS_WIDTH = 32) extends uvm_test;
    
    `uvm_component_utils(instr_mem_base_test#(BUS_WIDTH))
    
    // Environment
    instr_mem_env#(BUS_WIDTH) env;
    
    // Constructor
    function new(string name = "instr_mem_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = instr_mem_env#(BUS_WIDTH)::type_id::create("env", this);
        `uvm_info(get_name(), "Build Phase Complete", UVM_LOW)
    endfunction
    
    // End of elaboration phase
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction
    
    // Run phase - override in derived tests
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "Test Started", UVM_LOW)
        #1000ns; // Default timeout
        `uvm_info(get_name(), "Test Completed", UVM_LOW)
        phase.drop_objection(this);
    endtask
    
endclass: instr_mem_base_test

// Simple sequential test
class instr_mem_simple_test#(parameter BUS_WIDTH = 32) extends instr_mem_base_test#(BUS_WIDTH);
    
    `uvm_component_utils(instr_mem_simple_test#(BUS_WIDTH))

    function new(string name = "instr_mem_simple_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        instr_mem_sequence#(BUS_WIDTH) seq;
        phase.raise_objection(this);
        `uvm_info(get_name(), "=== Starting Simple Sequential Test ===", UVM_NONE)
        seq = instr_mem_sequence#(BUS_WIDTH)::type_id::create("seq");
        seq.start(env.agent.sequencer);
        #100ns;
        `uvm_info(get_name(), "=== Simple Test Completed ===", UVM_NONE)
        phase.drop_objection(this);
    endtask
endclass: instr_mem_simple_test

// Out-of-bounds test
class instr_mem_oob_test#(parameter BUS_WIDTH = 32) extends instr_mem_base_test#(BUS_WIDTH);
    
    `uvm_component_utils(instr_mem_oob_test#(BUS_WIDTH))
    function new(string name = "instr_mem_oob_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        oob_instr_mem_sequence#(BUS_WIDTH) seq;
        phase.raise_objection(this);
        `uvm_info(get_name(), "=== Starting Out-of-Bounds Test ===", UVM_NONE)
        seq = oob_instr_mem_sequence#(BUS_WIDTH)::type_id::create("seq");
        seq.start(env.agent.sequencer);
        #100;
        `uvm_info(get_name(), "=== OOB Test Completed ===", UVM_NONE)
        phase.drop_objection(this);
    endtask
    
endclass: instr_mem_oob_test

`endif
