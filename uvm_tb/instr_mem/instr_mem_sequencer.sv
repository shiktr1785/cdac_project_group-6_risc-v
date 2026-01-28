`ifndef __INSTR_MEM_SEQUENCER_SV
`define __INSTR_MEM_SEQUENCER_SV

class instr_mem_sequencer#(parameter BUS_WIDTH = 32) extends uvm_sequencer#(instr_mem_seq_item#(BUS_WIDTH));

    `uvm_component_utils(instr_mem_sequencer#(BUS_WIDTH))

    function new(string name = "instr_mem_sequencer", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_name(), "New", UVM_HIGH) // For debugging
    endfunction: new

endclass: instr_mem_sequencer

`endif


