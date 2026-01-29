`ifndef __REGFILE_AGENT_SV
`define __REGFILE_AGENT_SV

class regfile_agent #(parameter BUS_WIDTH = 32, parameter ADDR_WIDTH = 15) extends uvm_agent;
    `uvm_component_utils(regfile_agent #(BUS_WIDTH, ADDR_WIDTH))

    regfile_driver #(BUS_WIDTH, ADDR_WIDTH) driver;
    regfile_monitor #(BUS_WIDTH, ADDR_WIDTH) monitor;
    regfile_sequencer #(BUS_WIDTH, ADDR_WIDTH) sequencer;

    function new(string name="regfile_agent", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(),"New",UVM_HIGH)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor=regfile_monitor#(BUS_WIDTH, ADDR_WIDTH)::type_id::create("monitor", this);
        if(get_is_active() == UVM_ACTIVE) begin
            driver=regfile_driver#(BUS_WIDTH, ADDR_WIDTH)::type_id::create("driver", this);
            sequencer=regfile_sequencer#(BUS_WIDTH, ADDR_WIDTH)::type_id::create("sequencer", this);
        end
        `uvm_info(get_name(),"Build Phase",UVM_HIGH)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end

        `uvm_info(get_name(),"Connect Phase",UVM_HIGH)
        
    endfunction:connect_phase

endclass : regfile_agent

`endif
