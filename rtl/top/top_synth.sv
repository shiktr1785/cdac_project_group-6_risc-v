//`include "rtl/common/includes_synth.sv"
module top_synth (
//    output logic [31:0] alu_data_out,
//    output logic [3:0] opcode,
//    input logic store_en,
//    input logic [5:0] store_address,
//    input logic [31:0] store_data,
    input bit clk,
    input reset_n
);

  // Internal Wires & Buses
(* MARK_DEBUG = "true" *)wire [31:0] alu_data_out;
wire [3:0] opcode;
  // Instruction Memory Interface
  (* MARK_DEBUG = "true" *)(* DONT_TOUCH = "yes" *)wire [31:0] instr;
  (* MARK_DEBUG = "true" *)(* keep = "true" *)wire        instr_valid;
  (* MARK_DEBUG = "true" *)wire        next_instr;

  // Decoder

  (* keep = "true" *)wire [31:0] imme_data;
  (* keep = "true" *)wire        rd2_imme_sel;
  (* keep = "true" *)wire [14:0] rs1_rs2_rd;
  (* MARK_DEBUG = "true" *)wire        rs_addr_valid;
  (* MARK_DEBUG = "true" *)wire        rs_store;
  wire        rd_wr_en;

  // Mux Output
  wire [31:0] imme_rs;

  // Register File Data
  (* keep = "true" *)wire [31:0] rs_data;
  (* keep = "true" *)wire [31:0] rs_data_mux;
  wire        op_done;


  (* MARK_DEBUG = "true" *)(* keep = "true" *)wire        alu_data_valid;

  wire        final_wr_en;
  assign final_wr_en = rd_wr_en & alu_data_valid;

  (* MARK_DEBUG = "true" *)wire op_done_final;
  assign op_done_final = op_done;

  // rd2_imme_sel - 0 for imme, 1 for rs2
  assign imme_rs = (rd2_imme_sel) ? rs_data_mux : imme_data;

  // Module Instantiations

  // 1) Instruction Memory
  (* DONT_TOUCH = "yes" *) instr_mem_synth i_inst_mem (
      .clk          (clk),
      .reset_n      (reset_n),
      .next_instr   (next_instr),     // Input from Decoder
      .instr        (instr),          // Output to Decoder
      .instr_valid  (instr_valid)     // Output to Decoder
  );

  // 2) Decoder
  (* keep = "true" *) decoder_v2 i_decoder (
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
  (* DONT_TOUCH = "yes" *) regfile i_regfile (
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
  (* DONT_TOUCH = "yes" *) alu i_alu (
      .rs_data       (rs_data),        // Operand 1 -from RegFile
      .imme_rs       (imme_rs),        // Operand 2 - from Mux
      .opcode        (opcode),         // Control - from Decoder
      .alu_data_out  (alu_data_out),   // Result - to RegFile
      .alu_data_valid(alu_data_valid)  // Status 
  );

endmodule


