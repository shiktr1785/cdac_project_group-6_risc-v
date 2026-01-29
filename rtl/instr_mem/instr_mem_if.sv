    `ifndef __INSTR_MEM_IF_SV
    `define __INSTR_MEM_IF_SV

    interface instr_mem_if#(parameter BUS_WIDTH = 32)(input bit clk);
        
        // Signals
        logic                   reset_n;
        logic                   next_instr;
        logic [BUS_WIDTH-1:0]   instr;
        logic                   instr_valid;

        // Clocking block for synchronization

        `ifndef VERILATOR
        clocking drv_cb @(posedge clk);
            default input #1step output #1;
            output reset_n;
            output next_instr;
            input  instr;
            input  instr_valid;
        endclocking

        clocking mon_cb @(posedge clk);
            default input #1step output #1;
            input  reset_n;
            input  next_instr;
            input  instr;
            input  instr_valid;
        endclocking

        `endif
        
        // Modport for driver
        modport driver (
            input  clk,
            output reset_n,
            output next_instr,
            input  instr,
            input  instr_valid
        );

        // Modport for monitor
        modport monitor (
            input clk,
            input reset_n,
            input next_instr,
            input instr,
            input instr_valid
        );

    endinterface: instr_mem_if

    `endif



