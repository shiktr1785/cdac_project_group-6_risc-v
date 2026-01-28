`ifndef __ALU_IF_SV
`define __ALU_IF_SV

interface alu_if #(
    parameter BUS_WIDTH = 32, 
    parameter OPCODE_WIDTH = 4
) (input bit clk);

    // Signals
    logic [BUS_WIDTH-1:0]       imme_rs;        // Immediate operations
    logic [BUS_WIDTH-1:0]       rs_data;        // RS Data
    logic [OPCODE_WIDTH-1:0]    opcode;         // Op_code
    logic [BUS_WIDTH-1:0]       alu_data_out;   // Output from ALU
    logic                       alu_data_valid; // Check whether output from alu valid or not

    `ifndef VERILATOR
    // Clocking block for synchronization
    clocking drv_cb @(posedge clk);
        default input #1step output #1;
        output imme_rs;
        output opcode;
        input  rs_data;
        input  alu_data_out;
        input  alu_data_valid;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step output #1;
        input  rs_data;
        input  alu_data_out;
        input  alu_data_valid;
        input  imme_rs;
        input  opcode;
    endclocking
    `endif

    // Modport for driver
    modport driver (
        input  clk,
        output imme_rs,
        output opcode,
        input  rs_data,
        input  alu_data_out,
        input  alu_data_valid
    ); 

    // Modport for monitor
    modport monitor (
        input clk,
        input rs_data,
        input alu_data_out,
        input alu_data_valid,
        input imme_rs,
        input opcode
    );

endinterface: alu_if

`endif

