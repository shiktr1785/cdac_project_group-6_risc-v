`ifndef __INSTR_MEM_IF_SV
`define __INSTR_MEM_IF_SV

interface instr_mem_if #(
    integer BUS_WIDTH = 32 )(
    input bit clk);

    logic                   next_instr;   //next_instr is output when current instruction is successfully executed
    logic [BUS_WIDTH-1:0]   instruction;  //the current instruction

    `ifndef VERILATOR
    clocking drv_cb @(posedge clk);
        
        //samples input before clock edge and output 1ns after clock edge
        default input #1step output #1;
        output instruction;
        input next_instr; 
           
    endclocking

    clocking mon_cb @(posedge clk);

        default input #1step output #1;
        input instruction;
        input next_instr;              
        
    endclocking
    `endif

    //driver direction
    modport driver 
    (
        output instruction,
        input next_instr
    ); 

    //monitor direction
    modport monitor
    (
        input instruction,
        input next_instr
    );
    

endinterface // instr_mem_if

`endif
