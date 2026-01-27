`include "rtl/common/includes.sv"
module top_v3 (
    output logic [31:0] alu_data_out,
    output logic [3:0] opcode,
    input logic store_en,
    input logic [5:0] store_address,
    input logic [31:0] store_data,
    input bit clk,
    input reset_n
);

  // Internal Wires & Buses

  // Instruction Memory Interface
  (* keep = "true" *)logic [31:0] instr;
  (* keep = "true" *)logic        instr_valid;
  logic        next_instr;

  // Decoder

  (* keep = "true" *)logic [31:0] imme_data;
  (* keep = "true" *)logic        rd2_imme_sel;
  (* keep = "true" *)logic [14:0] rs1_rs2_rd;
  logic        rs_addr_valid;
  logic        rs_store;
  logic        rd_wr_en;

  // Mux Output
  logic [31:0] imme_rs;

  // Register File Data
  (* keep = "true" *)logic [31:0] rs_data;
  (* keep = "true" *)logic [31:0] rs_data_mux;
  logic        op_done;


  (* keep = "true" *)logic        alu_data_valid;

  logic        final_wr_en;
  assign final_wr_en = rd_wr_en & alu_data_valid;

  logic op_done_final;
  assign op_done_final = op_done;

  // rd2_imme_sel - 0 for imme, 1 for rs2
  assign imme_rs = (rd2_imme_sel) ? rs_data_mux : imme_data;

  // Module Instantiations

  // 1) Instruction Memory
  instr_mem_v2 #(
      .DEPTH(64)
  ) i_inst_mem (
      .clk          (clk),
      .reset_n      (reset_n),
      .store_en     (store_en),
      .store_address(store_address),
      .store_data   (store_data),
      .next_instr   (next_instr),     // Input from Decoder
      .instr        (instr),          // Output to Decoder
      .instr_valid  (instr_valid)     // Output to Decoder
  );

  // 2) Decoder
  decoder_v2 i_decoder (
      .clk        (clk),
      .reset_n    (reset_n),
      .instr      (instr),
      .instr_valid(instr_valid),
      // To RegFile's op_done
      .op_done    (op_done_final),

      .next_instr   (next_instr),
      .opcode       (opcode),
      .imme_data    (imme_data),
      .rd2_imme_sel (rd2_imme_sel),
      .rs1_rs2_rd   (rs1_rs2_rd),
      .rs_addr_valid(rs_addr_valid),
      .rs_store     (rs_store),
      .rd_wr_en     (rd_wr_en)
  );

  // 3) Reg File
  regfile i_regfile (
      .clk    (clk),
      // Controls
      .rs_addr_valid(rs_addr_valid),
      .rs1_rs2_rd   (rs1_rs2_rd),
      .rd_wr_en     (final_wr_en),
      .rs_store     (rs_store),

      // For immediate store
      .imme_data(imme_data),

      // Write back data from ALU
      .alu_data_out(alu_data_out),

      .rs_data    (rs_data),      // Connected to ALU 
      .rs_data_mux(rs_data_mux),  // Connected to Mux 
      .op_done    (op_done)       // Connected to Decoder
  );

  // 4) ALU
  alu i_alu (
      .rs_data       (rs_data),        // Operand 1 -from RegFile
      .imme_rs       (imme_rs),        // Operand 2 - from Mux
      .opcode        (opcode),         // Control - from Decoder
      .alu_data_out  (alu_data_out),   // Result - to RegFile
      .alu_data_valid(alu_data_valid)  // Status 
  );

endmodule

