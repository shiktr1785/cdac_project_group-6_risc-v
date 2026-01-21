`ifndef __ALU_SEQUENCE_ITEM_SV
`define __ALU_SEQUENCE_ITEM_SV

class alu_sequence_item #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 7) extends uvm_sequence_item;
    `uvm_object_param_utils(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    
endclass : alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)

`endif
