`ifndef __ALU_TEST_SV
`define __ALU_TEST_SV

//Base Class to Build and Setup env
class alu_base_test #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends uvm_test;


  `uvm_component_param_utils(alu_base_test#(BUS_WIDTH, OPCODE_WIDTH))


  alu_env #(BUS_WIDTH, OPCODE_WIDTH) env;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("env", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agent", "is_active", UVM_ACTIVE);
  endfunction  // build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction  // end_of_elaboration_phase


endclass

//default sequences
class alu_test_random #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends alu_base_test #(BUS_WIDTH, OPCODE_WIDTH);

  `uvm_component_param_utils(alu_test_random#(BUS_WIDTH, OPCODE_WIDTH))

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction  // new


  task run_phase(uvm_phase phase);
    alu_sequence #(BUS_WIDTH, OPCODE_WIDTH) seq;

    phase.raise_objection(this);

    seq = alu_sequence#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq");
    `uvm_info(get_name(), "Starting Random Sequence", UVM_LOW)

    seq.start(env.agent.sqr);

    phase.drop_objection(this);
  endtask  // run_phase

endclass  // alu_test_random

//Legal Ops
class alu_test_legal #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends alu_base_test #(BUS_WIDTH, OPCODE_WIDTH);

  `uvm_component_param_utils(alu_test_legal#(BUS_WIDTH, OPCODE_WIDTH))

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction  // new


  task run_phase(uvm_phase phase);
    alu_sequence_legal_opcode #(BUS_WIDTH, OPCODE_WIDTH) seq;

    phase.raise_objection(this);

    seq = alu_sequence_legal_opcode#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq");
    `uvm_info(get_name(), "Starting Legal Opcode Sequence", UVM_LOW)

    seq.start(env.agent.sqr);

    phase.drop_objection(this);
  endtask  // run_phase


endclass

//Illegal Ops
class alu_test_illegal #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends alu_base_test #(BUS_WIDTH, OPCODE_WIDTH);

  `uvm_component_param_utils(alu_test_illegal#(BUS_WIDTH, OPCODE_WIDTH))

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction  // new


  task run_phase(uvm_phase phase);
    alu_sequence_illegal_opcode #(BUS_WIDTH, OPCODE_WIDTH) seq;

    phase.raise_objection(this);

    seq = alu_sequence_illegal_opcode#(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq");
    `uvm_info(get_name(), "Starting Illegal Opcode Sequence", UVM_LOW)

    seq.start(env.agent.sqr);

    phase.drop_objection(this);
  endtask  // run_phase


endclass

`endif
