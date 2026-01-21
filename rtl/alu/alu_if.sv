`ifndef __ALU_IF_SV
`define __ALU_IF_SV

interface alu_if#(
    integer BUS_WIDTH = 32, 
    integer OPCODE_WIDTH = 4);

    logic [BUS_WIDTH-1:0]       imme_value;     // Immediate operations
    logic [BUS_WIDTH-1:0]       rs_data;        // RS Data
    logic                       rs_data_sel;    // Selecting either rs1 or rs2
    logic                       rs_data_valid;  // Check whether valid or not
    logic [OPCODE_WIDTH-1:0]    op_code;        // Op_code
    logic [BUS_WIDTH-1:0]       alu_out;        // Output from ALU
    logic                       alu_valid_out;  // Check whether output from alu valid or not
    logic                       op_done;        // Current instruction done, now move on to the next instruction
    // op_done is response from DUT

endinterface

`endif
