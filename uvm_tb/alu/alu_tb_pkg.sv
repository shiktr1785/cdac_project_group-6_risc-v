`ifndef __ALU_TB_PKG_SV
`define __ALU_TB_PKG_SV


`include "uvm_macros.svh"

package alu_tb_pkg;

    // Include sequence item and sequence files
    import uvm_pkg::*;
    `include "alu_sequence_item.sv"
    `include "alu_sequence.sv"
    `include "alu_sequencer.sv"
    `include "alu_monitor.sv"
    `include "alu_driver.sv"
    `include "alu_agent.sv"
    `include "alu_scoreboard.sv"
    `include "alu_env.sv"
    `include "alu_test.sv"
    `include "alu.sv"
endpackage : alu_tb_pkg

`endif

