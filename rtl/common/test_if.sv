`ifndef __TEST_IF_SV
`define __TEST_IF_SV

//  Interface: test_if
//
interface test_if
    /*  package imports  */
    #(
        parameter integer DATA_WIDTH = 5
    )(
        logic clk
    );

    logic req;
    logic [DATA_WIDTH-1:0] grant;

    
endinterface: test_if

`endif
