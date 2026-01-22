`ifndef __ALU_SEQUENCE_ITEM_SV
`define __ALU_SEQUENCE_ITEM_SV

class alu_sequence_item #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 11) extends uvm_sequence_item;

    `uvm_object_utils(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));
    
    // Data members

        // Inputs

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

    function void do_print (uvm_printer printer);
        super.do_print(printer);
        printer.print_field_int("rs_data", rs_data, $bits(rs_data));
        printer.print_field_int("imme_value", imme_value, $bits(imme_value));
        printer.print_field_int("opcode", opcode, $bits(opcode));
        printer.print_field_int("rs_data_sel", rs_data_sel, $bits(rs_data_sel));
        printer.print_field_int("rs_data_valid", rs_data_valid, $bits(rs_data_valid));
        printer.print_field_int("alu_data_out", alu_data_out, $bits(alu_data_out));
        printer.print_field_int("alu_data_valid", alu_data_valid, $bits(alu_data_valid));
        printer.print_field_int("op_done", op_done, $bits(op_done));
    endfunction

    // Constraints

    constrain operand_boundary_c {
        rs_data inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
        if (rs_data_sel) begin
            imme_value inside {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF, 32'h80000000, 32'hAAAAAAAA, 32'h55555555}; // only taken as operand when rs_data_sel is 1
        end
    }

    constrain sel_c {
        rs_data_sel inside {0,1};
    }

    constrain opcode_c {
        if (inject_illegal_opcode) begin
            opcode outside { 11'h033, 11'h013, 11'h003, 11'h023, 11'h063, 11'h037, 11'h017, 11'h06F, 11'h067};
        end
        else begin
            opcode inside { 11'h033, 11'h013, 11'h003, 11'h023, 11'h063, 11'h037, 11'h017, 11'h06F, 11'h067};
        end
    }

endclass : alu_sequence_item


`endif