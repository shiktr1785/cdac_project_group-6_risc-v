`ifndef __REGFILE_PKG_SV
`define __REGFILE_PKG_SV

`include "uvm_macros.svh"

package regfile_tb_pkg;

    import uvm_pkg::*;
    // Include sequence item and sequence files

    `include "regfile_sequence_item.sv"
    `include "regfile_sequence.sv"

endpackage : regfile_tb_pkg

`endif
