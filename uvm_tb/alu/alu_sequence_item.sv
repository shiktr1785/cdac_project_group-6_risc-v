`ifndef __ALU_SEQUENCE_ITEM_SV
`define __ALU_SEQUENCE_ITEM_SV

class alu_sequence_item #(
    parameter integer BUS_WIDTH = 32,
    parameter integer OPCODE_WIDTH = 4
) extends uvm_sequence_item;

    `uvm_object_utils(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH))
        
    // Variables
    rand logic [BUS_WIDTH - 1 : 0] rs_data;
    rand logic [BUS_WIDTH - 1 : 0] imme_value;

    randc logic [OPCODE_WIDTH - 1 : 0] opcode;
    
         bit rs_data_valid;
         bit rs_data_sel;
         
        // Outputs
    
    logic [BUS_WIDTH - 1 : 0] alu_data_out;
    logic alu_data_valid;
    logic op_done; 

    // Constructor

    function new(string name = "alu_sequence_item");
        super.new(name);
    endfunction

    // Print method 
    function void print();
        `uvm_info(get_type_name(), $sformatf("rs_data: %0h, imme_value: %0h, opcode: %0h, rs_data_sel: %0b, rs_data_valid: %0b, alu_data_out: %0h, alu_data_valid: %0b, op_done: %0b",
            rs_data, imme_value, opcode, rs_data_sel, rs_data_valid, alu_data_out, alu_data_valid, op_done), UVM_LOW)
    endfunction

endclass : alu_sequence_item


`endif
