`ifndef __INSTR_MEM_ENV_SV
`define __INSTR_MEM_ENV_SV

class instr_mem_env #(parameter BUS_WIDTH = 32) extends uvm_env;

    `uvm_component_utils(instr_mem_env#(BUS_WIDTH))

    // Components
    instr_mem_agent #(BUS_WIDTH) agent;
    instr_mem_scoreboard #(BUS_WIDTH) scoreboard;

    // Constructor
    function new(string name = "instr_mem_env", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(), "New", UVM_HIGH)
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Agent and Scoreboard
        agent = instr_mem_agent#(BUS_WIDTH)::type_id::create("agent", this);
        scoreboard = instr_mem_scoreboard#(BUS_WIDTH)::type_id::create("scoreboard", this);
         `uvm_info(get_name(), "Build Phase", UVM_HIGH)
    endfunction : build_phase

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
         // Connect Monitor Analysis Port to Scoreboard Analysis Export
        agent.monitor.instr_ap.connect(scoreboard.analysis_imp);
        `uvm_info(get_name(), "Connect Phase", UVM_HIGH)
    endfunction : connect_phase

endclass : instr_mem_env

`endif
