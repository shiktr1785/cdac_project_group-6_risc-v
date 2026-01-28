`ifndef __ALU_ENV_SV
`define __ALU_ENV_SV

class alu_env #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends uvm_env;
  `uvm_component_param_utils(alu_env#(BUS_WIDTH, OPCODE_WIDTH))

  alu_agent #(BUS_WIDTH, OPCODE_WIDTH)      agent;
  alu_scoreboard #(BUS_WIDTH, OPCODE_WIDTH) sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_name(), "ENV_NEW_PHASE", UVM_HIGH)
  endfunction
  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = alu_agent#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("agent", this);
    sb    = alu_scoreboard#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("sb", this);
    `uvm_info(get_name(), "ENV_BUILD_PHASE", UVM_HIGH)
  endfunction  // build_phase


  // Connect Phase
  function void connect_phase(uvm_phase phase);
    agent.mon.ap.connect(sb.item_collected_export);
    `uvm_info(get_name(), "ENV_CONNECT_PHASE", UVM_HIGH)
  endfunction  // connect_phase


endclass
`endif
