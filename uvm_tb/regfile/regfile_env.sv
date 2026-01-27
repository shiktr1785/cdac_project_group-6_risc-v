`ifndef __REGFILE_ENV_SV
`define __REGFILE_ENV_SV

class regfile_env #(parameter BUS_WIDTH = 32, parameter ADDR_WIDTH = 15) extends uvm_env;
    `uvm_component_utils(regfile_env #(BUS_WIDTH, ADDR_WIDTH))

    // Components
    regfile_agent #(BUS_WIDTH, ADDR_WIDTH) agent;
    regfile_scoreboard #(BUS_WIDTH, ADDR_WIDTH) scoreboard; 

    // Constructor
    function new(string name = "regfile_env", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(), "New", UVM_HIGH)
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Agent and Scoreboard
        agent = regfile_agent#(BUS_WIDTH, ADDR_WIDTH)::type_id::create("agent", this);
        scoreboard = regfile_scoreboard#(BUS_WIDTH, ADDR_WIDTH)::type_id::create("scoreboard", this);
         `uvm_info(get_name(), "Build Phase", UVM_HIGH)
    endfunction : build_phase

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
         // Connect Monitor Analysis Port to Scoreboard Analysis Export
        agent.monitor.ap.connect(scoreboard.analysis_imp);
        `uvm_info(get_name(), "Connect Phase", UVM_HIGH)
    endfunction : connect_phase

endclass : regfile_env

`endif
