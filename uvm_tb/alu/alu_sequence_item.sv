`ifndef __ALU_SEQUENCE_ITEM_SV
`define __ALU_SEQUENCE_ITEM_SV

class alu_sequence_item #(
    parameter integer BUS_WIDTH = 32,
    parameter integer OPCODE_WIDTH = 4
) extends uvm_sequence_item;

    `uvm_object_utils(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH))
        
    // Variables
        // Inputs
    rand logic [BUS_WIDTH - 1 : 0] rs_data;
    rand logic [BUS_WIDTH - 1 : 0] imme_rs;
    randc logic [OPCODE_WIDTH - 1 : 0] opcode;
         
        // Outputs
    logic [BUS_WIDTH - 1 : 0] alu_data_out;
    logic alu_data_valid; 

    // Constructor

    function new(string name = "alu_sequence_item");
        super.new(name);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Display method 
    function void display();
        `uvm_info(get_type_name(), $sformatf("rs_data: %0h, imme_rs: %0h, opcode: %0h, alu_data_out: %0h, alu_data_valid: %0b",
            rs_data, imme_rs, opcode, alu_data_out, alu_data_valid), UVM_LOW)
        `uvm_info(get_name(), "Display", UVM_HIGH)
    endfunction

endclass : alu_sequence_item


`endif
