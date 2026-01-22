`ifndef __REGFILE_IF_SV
`define __REGFILE_IF_SV

interface regfile_if #(
    integer BUS_WIDTH = 32,
    integer ADDR_WIDTH = 5
    )(input bit clk);


    //interface signals
    logic [ADDR_WIDTH-1:0]  rs_addr;
    logic                   rs_addr_sel;
    logic [ADDR_WIDTH-1:0]  rs_addr_valid;
    logic [ADDR_WIDTH-1:0]  rd_addr;
    logic [BUS_WIDTH-1:0]   rs_data;
    logic                   rs_data_sel;
    logic [BUS_WIDTH-1:0]   rs_data_valid;

    //  will skip this block
    `ifndef VERILATOR

    //Clocking Block for Driver and Monitor
    clocking drv_cb @(posedge clk);

        //Input is sampled in preponed region while output is sampled 1ns after clock edge
        default input #1step output #1;
        output rs_addr;
        output rs_addr_sel;
        output rd_addr;
        output rs_addr_valid;
        input  rs_data;
        input  rs_data_sel;
        input  rs_data_valid;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step output #1;
        input rs_addr;
        input rs_addr_sel;
        input rd_addr;
        input rs_addr_valid;
        input  rs_data;
        input  rs_data_sel;
        input  rs_data_valid;
    endclocking

    `endif

    //Defining directions for driver and monitor
    modport driver (
        output rs_addr,
        output rs_addr_sel,
        output rd_addr,
        output rs_addr_valid,
        input  rs_data,
        input  rs_data_sel,
        input  rs_data_valid);

    modport monitor (
        input rs_addr,
        input rs_addr_sel,
        input rd_addr,
        input rs_addr_valid,
        input  rs_data,
        input  rs_data_sel,
        input  rs_data_valid
    );


endinterface : regfile_if

`endif

