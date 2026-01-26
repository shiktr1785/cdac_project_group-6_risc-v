`ifndef __ALU_SEQUENCER_SV
`define __ALU_SEQUENCER_SV

class alu_sequencer #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends uvm_sequencer #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    `uvm_component_param_utils(alu_sequencer #(BUS_WIDTH, OPCODE_WIDTH));

    // Constructor

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass : alu_sequencer

`endif
