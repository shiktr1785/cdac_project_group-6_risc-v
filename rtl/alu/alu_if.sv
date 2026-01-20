`ifndef __ALU_IF_SV
`define __ALU_IF_SV

interface alu_if#(
    integer BUS_WIDTH = 32, 
    integer OPCODE_WIDTH = 11)
    (
        logic input clk
    );

    logic [BUS_WIDTH-1:0]      imme_value; // Immediate operations
    logic [BUS_WIDTH-1:0]         rs_data; // RS Data
    logic                     rs_data_sel; // Selecting either rs1 or rs2
    logic                   rs_data_valid; // Check whether valid or not
    logic [OPCODE_WIDTH-1:0]      op_code; // Op_code
    logic [BUS_WIDTH-1:0]         alu_out; // Output from ALU
    logic                   alu_valid_out; // Check whether output from alu valid or not
    logic                         op_done; // Current instruction done, now move on to the next instruction   

    // driver will send the signal, and receive the response
    // alu_out in response
    // op_done is response from DUT

    clocking drv_cb @(posedge clk);

        default input #1step output #1;
        input         op_done; // this input from DUT
        input         alu_out; // this input from DUT
        input   alu_valid_out; // this input from DUT
        output     imme_value; // this output to DUT
        output  rs_data_valid; // this output to DUT
        output        rs_data; // this output to DUT
        output        op_code; // this output to DUT
        output    rs_data_sel; // this output to DUT

    endclocking
`
    clocking mon_cb @(posedge clk);
        
        default input #1step output #1;
        output        op_done;
        output        alu_out;
        output  alu_valid_out;
        input      imme_value;
        input   rs_data_valid;
        input         rs_data;
        input         op_code;
        input     rs_data_sel;

    endclocking

    modport DRIVER( clocking drv_cb );
    modport MONITOR( clocking mon_cb );

endinterface

`endif
