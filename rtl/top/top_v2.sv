`include "rtl/common/includes.sv"
module top_v2;

  wire [ 3:0] opcode;
  wire [31:0] imme_data;
  wire        rd2_imme_sel;
  wire [14:0] rs1_rs2_rd;
  wire        rs_addr_valid;
  wire        rs_store;
  wire        rd_wr_en;
  wire        next_instr;
  wire [31:0] instr;
  wire        instr_valid;
  wire        op_done;
  wire        clk;
  wire        reset_n;
  wire [31:0] rs_data_mux;
  wire [31:0] rs_data;
  wire [31:0] alu_data_out;
  wire        alu_data_valid;

  decoder_v2 dv2 (
      // For alu
      .opcode(opcode),  // {funct7,funct3}
      .imme_data(imme_data),  //Sign extended output immediate data
      .rd2_imme_sel(rd2_imme_sel),  //Selecting between immediate and rs2 data in mux,
      // For reg file
      .rs1_rs2_rd(rs1_rs2_rd),
      .rs_addr_valid(rs_addr_valid),  //For controlling address to Reg File
      .rs_store(rs_store),  //For load and store
      .rd_wr_en(rd_wr_en),
      // For instr_mem
      .next_instr(next_instr),
      // Inputs
      .instr(instr),
      .instr_valid(instr_valid),
      .op_done(op_done),  // Ack from ALU
      // Globals
      .clk(clk),
      .reset_n(reset_n)
  );

  regfile reg1 (
      .clk(clk),
      .rs_addr_valid(rs_addr_valid),
      .rs1_rs2_rd(rs1_rs2_rd),
      .rs_wr_en(rs_wr_en),
      .rs_store(rs_store),
      .imme_data(imme_data),
      .alu_data_out(alu_data_out),
      .rs_data(rs_data),
      .rs_data_mux(rs_data_mux),
      .op_done(op_done)
  );
  mux21 mux1 (
      .imme_rs(imme_rs),
      .imme_data(imme_data),
      .rs_data_mux(rs_data_mux),
      .rd2_imme_sel(rd2_imme_sel)
  );

  alu alu1 (
      .rs_data(rs_data),
      .imme_rs(imme_rs),
      .opcode(opcode),
      .alu_data_out(alu_data_out),
      .alu_data_valid(alu_data_valid)
  );

  instr_mem_v1 instr_mem1 (
      .instr(instr),
      .next_instr(next_instr),
      .clk(clk),
      .reset_n(reset_n)
  );
endmodule  // top_risc_skele

module mux21 (
    output logic [31:0] imme_rs,
    input logic [31:0] imme_data,
    input logic [31:0] rs_data_mux,
    input logic rd2_imme_sel
);
  always_comb begin
    if (rd2_imme_sel) begin
      imme_rs = rs_data_mux;
    end else begin
      imme_rs = imme_data;
    end
  end

endmodule  // mux21


