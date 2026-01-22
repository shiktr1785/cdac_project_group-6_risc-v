`ifndef __ALU_SEQUENCE_RS_DATA_VALID_SV
`define __ALU_SEQUENCE_RS_DATA_VALID_SV

class alu_sequence_rs_data_valid #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 11) extends uvm_sequence #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    `uvm_object_param_utils(alu_sequence_rs_data_valid #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence_rs_data_valid");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Set the rs_data_valid flag
        seq_item.rs_data_valid = 1;

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body

endclass


`endif
