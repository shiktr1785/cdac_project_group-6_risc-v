`ifndef __ALU_TB_PKG_SV
`define __ALU_TB_PKG_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

package alu_tb_pkg;

    // Include sequence item and sequence files

    `include "alu_sequence_item.sv"
    `include "alu_sequence.sv"

endpackage : alu_tb_pkg

`endif
