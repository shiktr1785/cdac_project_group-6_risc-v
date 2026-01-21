`ifndef __REGFILE_IF_SV
`define __REGFILE_IF_SV

interface regfile_if #(
    integer BUS_WIDTH = 32,
    integer ADDR_WIDTH = 5,
    )(input logic clk)


    //interface signals
    logic [4:0]  rs_addr;
    logic        rs_addr_sel;
    logic [4:0]  rs_addr_valid;
    logic [4:0]  rd_addr;
    logic [31:0] rs_data;
    logic        rs_data_sel;
    logic [31:0] rs_data_valid;

    //Clocking Block for Driver and Monitor
    clocking drv_cb @(posedge clk);
        output rs_addr;
        output rs_addr_sel;
        output rd_addr;
        output rs_addr_valid;
        input  rs_data;
        input  rs_data_sel;
        input  rs_data_valid;
    endclocking

    clocking mon_cb @(posedge clk);
        output rs_addr;
        output rs_addr_sel;
        output rd_addr;
        output rs_addr_valid;
        input  rs_data;
        input  rs_data_sel;
        input  rs_data_valid;
    endclocking

    //Defining directions for driver and monitor
    modport driver @(clocking drv_cb);
    modport monitor @(clocking mon_cb);

endinterface : regfile_if

`endif

