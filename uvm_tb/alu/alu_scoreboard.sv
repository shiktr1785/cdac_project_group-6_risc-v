`ifndef __ALU_SCOREBOARD_SV
`define __ALU_SCOREBOARD_SV

class alu_scoreboard #(
    int BUS_WIDTH = 32,
    int OPCODE_WIDTH = 4
) extends uvm_scoreboard;

  `uvm_component_param_utils(alu_scoreboard#(BUS_WIDTH, OPCODE_WIDTH))

  uvm_analysis_imp #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH),
		     alu_scoreboard #(BUS_WIDTH, OPCODE_WIDTH)) item_collected_export;

  // Counters
  int m_matches, m_mismatches;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    m_matches = 0;
    m_mismatches = 0;
  endfunction  // new


  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction  // build_phase

  // Write Function
  virtual function void write(alu_sequence_item#(BUS_WIDTH, OPCODE_WIDTH) trans);
    logic [BUS_WIDTH-1:0] expected_data;
    logic [          4:0] shift_amt;
    bit                   result_match;

    shift_amt = trans.imme_rs[4:0];

    // Reference Model (Predictor)
    case (trans.opcode)
      4'b0000: expected_data = trans.rs_data + trans.imme_rs;  // ADD
      4'b1000: expected_data = trans.rs_data - trans.imme_rs;  // SUB
      4'b0001: expected_data = trans.rs_data << shift_amt;  // SLL
      4'b0010:
      expected_data = ($signed(trans.rs_data) < $signed(trans.imme_rs)) ? 32'd1 :
          32'd0;  // SLT (Signed)
      4'b0011: expected_data = (trans.rs_data < trans.imme_rs) ? 32'd1 : 32'd0;  // SLTU (Unsigned)
      4'b0100: expected_data = trans.rs_data ^ trans.imme_rs;  // XOR
      4'b0101: expected_data = trans.rs_data >> shift_amt;  // SRL
      4'b1101: expected_data = $signed(trans.rs_data) >>> shift_amt;  // SRA (Arithmetic Shift)
      4'b0110: expected_data = trans.rs_data | trans.imme_rs;  // OR
      4'b0111: expected_data = trans.rs_data & trans.imme_rs;  // AND
      default: expected_data = 32'b0;  // Illegal Opcode defaults to 0
    endcase  // reference model


    // Checker

    if (trans.alu_data_out !== expected_data) begin
      `uvm_error("SCBD_MISMATCH", $sformatf("OPCODE=%0h | A=%0h B=%0h | Expected=%0h Actual=%0h",
                                            trans.opcode, trans.rs_data, trans.imme_rs,
                                            expected_data, trans.alu_data_out))
      m_mismatches++;
    end else begin
      `uvm_info("SCBD_MATCH", $sformatf("OPCODE=%0h | Match: %0h", trans.opcode, expected_data),
                UVM_HIGH)
      m_matches++;
    end

  endfunction  // write

  // Report Phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCBD_SUMMARY", $sformatf(
              "Total Matches: %0d | Total Mismatches: %0d", m_matches, m_mismatches), UVM_LOW)
  endfunction  // report_phase

endclass  // alu_scoreboard


`endif
