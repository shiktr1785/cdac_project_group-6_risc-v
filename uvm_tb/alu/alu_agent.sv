`ifndef __ALU_AGENT_SV
`define __ALU_AGENT_SV

class alu_agent #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends uvm_agent;

  `uvm_component_param_utils(alu_agent#(BUS_WIDTH, OPCODE_WIDTH))

  alu_driver    #(BUS_WIDTH, OPCODE_WIDTH) drv;
  alu_monitor   #(BUS_WIDTH, OPCODE_WIDTH) mon;
  alu_sequencer #(BUS_WIDTH, OPCODE_WIDTH) sqr;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_name(), "Constructor", UVM_HIGH)
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon = alu_monitor#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("mon", this);

    if (get_is_active() == UVM_ACTIVE) begin
      drv = alu_driver#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("drv", this);
      sqr = alu_sequencer#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("sqr", this);
      `uvm_info(get_name(), "ACTIVE_AGENT_BUILD_PHASE", UVM_HIGH)
    end

    `uvm_info(get_name(), "AGENT_BUILD_PHASE", UVM_HIGH)
  endfunction  // build_phase


  // Connect Phase
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction  // connect_phase


endclass
`endif
