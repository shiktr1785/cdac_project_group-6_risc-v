`ifndef __DECODER_IF_SV
`define __DECODER_IF_SV

interface decoder_if #(
    integer BUS_WIDTH = 33,
    integer OPCODE_WIDTH = 5,
    integer ADDR_WIDTH = 5)
    (input logic clk);

    // Interface signals
    logic                       instr_valid;
    logic   [BUS_WIDTH-1:0]     instr; 
    logic   [OPCODE_WIDTH-1:0]  op_done;
    logic                       next_instr;
    
    logic   [BUS_WIDTH-1:0]     imme_value;
    logic   [OPCODE_WIDTH-1:0]  opcode;
    logic   [ADDR_WIDTH-1:0]    rd_addr;
    logic   [ADDR_WIDTH-1:0]    rs_addr;
    logic                       rs_addr_sel;
    logic                       rs_addr_valid;

`ifndef VERILATOR
    // Verilator will skip this block
    clocking drv_cb @(posedge clk);
        default input #1step output #1;      
        output instr_valid, instr, op_done, next_instr;
        input  imme_value, opcode, rd_addr, rs_addr, rs_addr_sel, rs_addr_valid;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step output #1;
        input instr, instr_valid, op_done, next_instr; // Fixed: Monitor should input these
        input imme_value, opcode, rd_addr, rs_addr, rs_addr_sel, rs_addr_valid;
    endclocking
`endif

    // Modports for Synthesis/Verilator
    modport driver (
        input  imme_value, opcode, rd_addr, rs_addr, rs_addr_sel, rs_addr_valid,
        output instr_valid, instr, op_done, next_instr
    );

    modport monitor (
        input instr, instr_valid, op_done, next_instr,
        input imme_value, opcode, rd_addr, rs_addr, rs_addr_sel, rs_addr_valid
    );

endinterface : decoder_if

`endif
