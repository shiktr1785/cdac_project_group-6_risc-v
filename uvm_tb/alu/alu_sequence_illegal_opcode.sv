`ifndef __ALU_SEQUENCE_ILLEGAL_OPCODE_SV
`define __ALU_SEQUENCE_ILLEGAL_OPCODE_SV

class alu_sequence_illegal_opcode #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 11) extends uvm_sequence #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    `uvm_object_param_utils(alu_sequence_illegal_opcode #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence_illegal_opcode");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Set the illegal opcode flag
        seq_item.inject_illegal_opcode = 1;

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body

endclass

`endif
