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
endpackage : alu_tb_pkg

`endif

