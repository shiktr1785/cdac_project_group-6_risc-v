`ifndef __ALU_SEQUENCE_ITEM_SV
`define __ALU_SEQUENCE_ITEM_SV

class alu_sequence_item #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 11) extends uvm_sequence_item;
    // Data members

    rand logic [BUS_WIDTH - 1 : 0] rs_data;
    rand logic [BUS_WIDTH - 1 : 0] imme_value;

    rand bit rs_data_sel;

    logic [OPCODE_WIDTH - 1 : 0] opcode; // Opcode is not random
    
    rand bit rs_data_valid;
    rand bit inject_illegal_opcode;

    // Constructor

    function new(string name = "alu_sequence_item");
        super.new(name);
    endfunction

    // Factory Registration + Field automation

    `uvm_object_param_utils_begin(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH))

        `uvm_field_int (rs_data , UVM_DEFAULT)
        `uvm_field_int (imme_value , UVM_DEFAULT)
        `uvm_field_int (rs_data_sel , UVM_DEFAULT)
        `uvm_field_int (rs_data_valid , UVM_DEFAULT)
        `uvm_field_int (inject_illegal_opcode , UVM_DEFAULT)
        `uvm_field_int (opcode , UVM_DEFAULT)

    `uvm_object_param_utils_end

    // Constraints

    constraint opcode_illegal_c {
        if (inject_illegal_opcode) begin
            !( opcode inside { 11'h033, 11'h013, 11'h003, 11'h023, 11'h063, 11'h037, 11'h017, 11'h06F, 11'h067} )
        end
        else begin
            ( opcode inside { 11'h033, 11'h013, 11'h003, 11'h023, 11'h063, 11'h037, 11'h017, 11'h06F, 11'h067} )
        end
    }

    constraint operand_boundary_c {
        rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (rs_data_sel) begin
            imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
        end
    }

    constraint sel_c {
        rs_data_sel inside {0,1};
    }


endclass : alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)

`endif
