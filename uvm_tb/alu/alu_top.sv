`timescale 1ns / 1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "alu_tb_pkg.sv"

module alu_top;

  parameter int BUS_WIDTH = 32;
  parameter int OPCODE_WIDTH = 4;
  logic clk;

  //Clock Gen
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end  //Clock Gen


  alu_if #(BUS_WIDTH, OPCODE_WIDTH) alu_intf (clk);


  // DUT Instantiation
  alu dut (
      .rs_data       (alu_intf.rs_data),
      .imme_rs       (alu_intf.imme_rs),
      .opcode        (alu_intf.opcode),
      .alu_data_out  (alu_intf.alu_data_out),
      .alu_data_valid(alu_intf.alu_data_valid)
  );

  // Starting Tests
  initial begin
    uvm_config_db#(virtual alu_vif #(BUS_WIDTH, OPCODE_WIDTH))::set(null, "*", "alu_vif", alu_intf);
    run_test();
  end

endmodule
