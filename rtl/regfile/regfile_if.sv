`ifndef __REGFILE_IF_SV
`define __REGFILE_IF_SV

interface regfile_if #(
    parameter BUS_WIDTH = 32,
    parameter ADDR_WIDTH = 15
) (input bit clk);

    // Signals
    logic                   rs_store;
    logic                   rs_addr_valid;
    logic [BUS_WIDTH-1:0]   rs_data;
    logic [BUS_WIDTH-1:0]   rs_data_mux;
    logic [ADDR_WIDTH-1:0]  rs1_rs2_rd;
    logic [BUS_WIDTH-1:0]   imme_data;
    logic                   op_done;
    logic                   rd_wr_en;
    logic                   alu_data_valid;
    logic [BUS_WIDTH-1:0]   alu_data_out;

    `ifndef VERILATOR
    // Clocking block for synchronization
    clocking drv_cb @(posedge clk);
        default input #1step output #1;
        output rs_store;
        output rs1_rs2_rd;
        output rd_wr_en;
        output rs_addr_valid;
        output imme_data;
        output op_done;
        output rs_data_mux;
        input  rs_data;
        input  alu_data_out;
        input  alu_data_valid;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step output #1;
        input  rs_store;
        input  rs1_rs2_rd;
        input  rd_wr_en;
        input  rs_addr_valid;
        input  imme_data;
        input  op_done;
        input  rs_data_mux;
        input  rs_data;
        input  alu_data_out;
        input  alu_data_valid;
    endclocking
    `endif

    // Modport for driver
    modport driver (
        input  clk,
        output rs_store,
        output rs_addr_valid,
        output rs1_rs2_rd,
        output rd_wr_en,
        output imme_data,
        output op_done,
        output rs_data_mux,
        input  rs_data,
        input  alu_data_out,
        input  alu_data_valid
    );

    // Modport for monitor
    modport monitor (
        input clk,
        input rs_store,
        input rs_addr_valid,
        input rs1_rs2_rd,
        input rd_wr_en,
        input imme_data,
        input op_done,
        input rs_data_mux,
        input rs_data,
        input alu_data_out,
        input alu_data_valid
    );

endinterface: regfile_if

`endif


