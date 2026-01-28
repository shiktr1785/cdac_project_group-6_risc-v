`ifndef __INSTR_MEM_AGENT_SV
`define __INSTR_MEM_AGENT_SV

class instr_mem_agent #(parameter BUS_WIDTH = 32) extends uvm_agent;
    `uvm_component_utils(instr_mem_agent#(BUS_WIDTH))

    instr_mem_driver #(BUS_WIDTH) driver;
    instr_mem_monitor #(BUS_WIDTH) monitor;
    instr_mem_sequencer #(BUS_WIDTH) sequencer;

    function new(string name="instr_mem_agent", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(),"New",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor=instr_mem_monitor#(BUS_WIDTH)::type_id::create("monitor", this);
        if(get_is_active() == UVM_ACTIVE) begin
            driver=instr_mem_driver#(BUS_WIDTH)::type_id::create("driver", this);
            sequencer=instr_mem_sequencer#(BUS_WIDTH)::type_id::create("sequencer", this);
        end
        `uvm_info(get_name(),"Build Phase",UVM_MEDIUM)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end

        `uvm_info(get_name(),"Connect Phase",UVM_MEDIUM)
        
    endfunction:connect_phase
endclass

`endif
