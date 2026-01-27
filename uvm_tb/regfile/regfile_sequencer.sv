`ifndef __REGFILE_SEQUENCER_SV
`define __REGFILE_SEQUENCER_SV

class regfile_sequencer #(
    int ADDR_WIDTH = 15,
    int BUS_WIDTH = 32
) extends uvm_sequencer #(regfile_seq_item #(ADDR_WIDTH, BUS_WIDTH));

    `uvm_component_param_utils(regfile_sequencer #(ADDR_WIDTH, BUS_WIDTH));

    // Constructor

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

endclass : regfile_sequencer

`endif
