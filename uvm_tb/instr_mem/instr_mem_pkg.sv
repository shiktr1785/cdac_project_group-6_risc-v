
`ifndef INSTR_MEM_PKG_SV
`define INSTR_MEM_PKG_SV

package instr_mem_pkg;

    import uvm_pkg::*;

    `include "uvm_macros.svh"
    `include "instr_mem_seq_item.sv"
    `include "instr_mem_sequence.sv"
    `include "instr_mem_sequencer.sv"
    `include "instr_mem_driver.sv"
    `include "instr_mem_monitor.sv"
    `include "instr_mem_scoreboard.sv"
    `include "instr_mem_agent.sv"
    `include "instr_mem_env.sv"

endpackage

`endif



