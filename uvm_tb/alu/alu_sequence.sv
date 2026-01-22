`ifndef __ALU_SEQUENCE_SV
`define __ALU_SEQUENCE_SV

class alu_sequence #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends uvm_sequence #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    `uvm_object_param_utils(alu_sequence #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body

    // Constraints

    constraint opcode_c {
        if (seq_item.inject_illegal_opcode) 
            !(seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111});
        else 
            seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
    }

    constraint boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (seq_item.rs_data_sel) 
            seq_item.imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
    }

endclass

class alu_sequence_illegal_opcode #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends alu_sequence #(BUS_WIDTH, OPCODE_WIDTH);

    `uvm_object_param_utils(alu_sequence_illegal_opcode #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence_illegal_opcode");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Set the illegal opcode flag to 1
        seq_item.inject_illegal_opcode = 1;
        seq_item.rs_data_valid = 1; // Ensure rs_data is valid for this test

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body

    // Constraints for illegal opcode

    constraint opcode_c {
        if (seq_item.inject_illegal_opcode) 
            !(seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111});
    }

    constraint boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (seq_item.rs_data_sel) 
            seq_item.imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
    }

endclass

class alu_sequence_legal_opcode #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends alu_sequence #(BUS_WIDTH, OPCODE_WIDTH);

    `uvm_object_param_utils(alu_sequence_legal_opcode #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence_legal_opcode");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Set the illegal opcode flag to 0 for legal opcode
        seq_item.inject_illegal_opcode = 0;
        seq_item.rs_data_valid = 1; // Ensure rs_data is valid for this test

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body

    // Constraints for legal opcode

    constraint opcode_c {
        if (!seq_item.inject_illegal_opcode) 
            seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
    }

    constraint boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (seq_item.rs_data_sel) 
            seq_item.imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
    }

endclass

class alu_sequence_rs_data_invalid #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends alu_sequence #(BUS_WIDTH, OPCODE_WIDTH);

    `uvm_object_param_utils(alu_sequence_rs_data_invalid #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence_rs_data_invalid");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Set the rs_data_valid flag to 0 (invalid)
        seq_item.rs_data_valid = 0;
        seq_item.inject_illegal_opcode = 0; // Ensure opcode is legal for this test

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body
    
    constraint opcode_c {
        if (!seq_item.inject_illegal_opcode) 
            seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
    }

    constraint boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (seq_item.rs_data_sel) 
            seq_item.imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
    }

endclass

class alu_sequence_rs_data_valid #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends alu_sequence #(BUS_WIDTH, OPCODE_WIDTH);

    `uvm_object_param_utils(alu_sequence_rs_data_valid #(BUS_WIDTH, OPCODE_WIDTH));
    alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
    
    // Constructor

    function new(string name = "alu_sequence_rs_data_valid");
        super.new(name);
    endfunction

    // Body task

    virtual task body();
        seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");

        // Set the rs_data_valid flag to 1 (valid)
        seq_item.rs_data_valid = 1;
        seq_item.inject_illegal_opcode = 0; // Ensure opcode is legal for this test

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body
    
    constraint opcode_c {
        if (!seq_item.inject_illegal_opcode) 
            seq_item.opcode inside { 4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
    }

    constraint boundary_c {
        seq_item.rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (seq_item.rs_data_sel) 
            seq_item.imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
    }

endclass

`endif
