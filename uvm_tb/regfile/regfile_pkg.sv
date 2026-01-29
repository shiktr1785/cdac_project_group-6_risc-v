`ifndef __REGFILE_PKG_SV
`define __REGFILE_PKG_SV

`include "uvm_macros.svh"

package regfile_tb_pkg;

    import uvm_pkg::*;
    // Include sequence item and sequence files

    `include "regfile_seq_item.sv"
    `include "regfile_sequencer.sv"
    `include "regfile_driver.sv"
    `include "regfile_monitor.sv"
    `include "regfile_sequence.sv"
    `include "regfile_reference_model.sv" 
    `include "regfile_scoreboard.sv"
    `include "regfile_agent.sv"
    `include "regfile_env.sv"

endpackage : regfile_tb_pkg

`endif
