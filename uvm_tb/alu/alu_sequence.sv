`ifndef __ALU_SEQUENCE_SV
`define __ALU_SEQUENCE_SV

class alu_sequence #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends uvm_sequence #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    `uvm_object_param_utils(alu_sequence #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence");
        super.new(name);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
        `uvm_info(get_name(), "Body", UVM_HIGH)
    endtask : body

    // Constraints

    constraint opcode_c {
            soft seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
    }

    constraint rs_data_boundary_c {
        soft seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

    constraint imme_value_boundary_c {
        soft seq_item.imme_rs inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

endclass

class alu_sequence_illegal_opcode #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends alu_sequence #(BUS_WIDTH, OPCODE_WIDTH);

    `uvm_object_param_utils(alu_sequence_illegal_opcode #(BUS_WIDTH, OPCODE_WIDTH));
    
    // Constructor

    function new(string name = "alu_sequence_illegal_opcode");
        super.new(name);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
        `uvm_info(get_name(), "Body", UVM_HIGH)
    endtask : body

    // Constraints for illegal opcode

    constraint opcode_c {
            !(seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111});
    }

    constraint boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

    constraint imme_value_boundary_c {
        seq_item.imme_rs inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

endclass

class alu_sequence_legal_opcode #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends alu_sequence #(BUS_WIDTH, OPCODE_WIDTH);

    `uvm_object_param_utils(alu_sequence_legal_opcode #(BUS_WIDTH, OPCODE_WIDTH));
    
    // Constructor

    function new(string name = "alu_sequence_legal_opcode");
        super.new(name);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
        `uvm_info(get_name(), "Body", UVM_HIGH)
    endtask : body

    // Constraints for legal opcode

    constraint opcode_c {
            seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
    }

    constraint rs_data_boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

    constraint imme_value_boundary_c {
        seq_item.imme_rs inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

endclass

`endif
