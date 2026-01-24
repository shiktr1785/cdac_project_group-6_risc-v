`ifndef __ALU_IF_SV
`define __ALU_IF_SV

interface alu_if#(
    integer BUS_WIDTH = 32, 
    integer OPCODE_WIDTH = 4);

    logic [BUS_WIDTH-1:0]       imme_rs;     // Immediate operations
    logic [BUS_WIDTH-1:0]       rs_data;        // RS Data
    logic [OPCODE_WIDTH-1:0]    op_code;        // Op_code
    logic [BUS_WIDTH-1:0]       alu_data_out;        // Output from ALU
    logic                       alu_data_valid;  // Check whether output from alu valid or not


endinterface

`endif
