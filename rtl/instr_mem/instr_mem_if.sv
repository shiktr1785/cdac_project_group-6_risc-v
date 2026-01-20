`ifndef __INSTR_MEM_IF_SV
`define __INSTR_MEM_IF_SV

interface instr_mem_if #(
    integer BUS_WIDTH = 32 )(
    input logic clk);

    logic                next_instr;             //next_instr is output when current instruction is successfully executed
    logic [BUS_WIDTH-1:0] instruction;            //the current instruction

    clocking drv_cb @(posedge clk);
        default input #1step output #1;
        //samples input before clock edge and output 1ns after clock edge
        input next_instr;
        //driver drives next_instr and reads the current instruction
        output instruction;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step output #1;
            input next_instr;              //Monitor reads both next_instr and instruction
            output instruction;
    endclocking

    modport driver (clocking drv_cb); 
    //driver direction
    modport monitor(clocking mon_cb);
    //monitor direction

endinterface // instr_mem_if

`endif
