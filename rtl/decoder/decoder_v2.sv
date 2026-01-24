module decoder_v2 (
    // For alu
    output logic [ 3:0] opcode,         // {funct7,funct3}
    output logic [31:0] imme_value,     //Sign extended output immediate data
    output logic        rd2_imme_sel,   //Selecting between immediate and rs2 data in mux,
    // For reg file
    output logic [14:0] rs1_rs2_rd,
    output logic        rs_addr_valid,  //For controlling address to Reg File
    output logic        rs_store,       //For load and store
    output logic        rd_wr_en,
    // For instr_mem
    output logic        next_instr,
    // Inputs
    input  logic [31:0] instr,
    input  logic        instr_valid,
    input  logic        op_done,        // Ack from ALU
    // Globals
    input  logic        clk,
    input  logic        reset_n
);

  // --------------------------------------------------------------------------
  // Type Definitions
  // --------------------------------------------------------------------------

  // Enum for the Instruction Type (Decoded from Opcode)
  typedef enum logic [6:0] {
    UDEF   = 7'b000_0000,
    I_TYPE = 7'b001_0011,
    R_TYPE = 7'b011_0011,
    S_TYPE = 7'b000_0011
  } instr_type_e;

  typedef enum logic [1:0] {
    STATE_IDLE,
    STATE_RS1_RS2_RD_IMME,     // Read first operand
    STATE_EXECUTE  // Wait for ALU / Finish
  } state_e;

  // --------------------------------------------------------------------------
  // Internal Signals
  // --------------------------------------------------------------------------
  logic [31:0] instr_reg;
  instr_type_e decoded_instr_type;
  state_e current_state, next_state;

  // --------------------------------------------------------------------------
  // 1. Input Registration (Sequential)
  // --------------------------------------------------------------------------
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      instr_reg <= 32'b0;
    end else if (instr_valid && current_state == STATE_IDLE) begin
      instr_reg <= instr;  // Latch new instruction only when IDLE and valid
    end else begin
      instr_reg <= instr_reg;
    end
  end

  // --------------------------------------------------------------------------
  // 2. Opcode Decoder (Combinational)
  // Maps the raw 7-bit opcode to our easy-to-read Enum.
  // --------------------------------------------------------------------------
  always_comb begin
    // Default to UDEF to prevent latches and handle unknown opcodes
    case (instr_reg[6:0])
      7'b001_0011: decoded_instr_type = I_TYPE;
      7'b011_0011: decoded_instr_type = R_TYPE;
      7'b000_0011: decoded_instr_type = S_TYPE;
      default:     decoded_instr_type = UDEF;
    endcase
  end

  // --------------------------------------------------------------------------
  // 3. FSM Next State Logic (Combinational)
  // Determines the sequence of operations (Fetch -> RS1 -> RS2 -> Done)
  // --------------------------------------------------------------------------
  always_comb begin
    next_state = current_state;  // Default to hold state

    case (current_state)
      STATE_IDLE: begin
        if (instr_valid) begin
          // Start sequence based on instruction type
          next_state = STATE_RS1_RS2_RD_IMME;
        end
      end

      STATE_RS1_RS2_RD_IMME: begin
        // After reading RS1 we go to RD2_IMME_SEL where we switch between RS2 and IMME
        next_state = STATE_EXECUTE;
      end

      STATE_EXECUTE: begin
        // Handshake done, go back to IDLE
        if (op_done) begin
          next_state = STATE_IDLE;
        end else begin
          next_state = STATE_EXECUTE;
        end

      end

      default: next_state = STATE_IDLE;
    endcase
  end

  // --------------------------------------------------------------------------
  // 4. FSM State Register (Sequential)
  // --------------------------------------------------------------------------
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      current_state <= STATE_IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  // --------------------------------------------------------------------------
  // Output Logic (Combinational)
  // Driven by current_state and decoded_instr_type
  // --------------------------------------------------------------------------
  always_comb begin

    // ALU Opcode extraction
    if (decoded_instr_type == UDEF) begin
      opcode = 4'b0;
    end else begin
      opcode = {instr_reg[30], instr_reg[14:12]};
    end

    // Immediate generation
    if (decoded_instr_type == I_TYPE) begin
      imme_value = {{21{instr_reg[31]}}, instr_reg[30:20]};
    end else if (decoded_instr_type == S_TYPE) begin
      imme_value = {{21{instr_reg[31]}}, instr_reg[30:25], instr_reg[11:7]};
      // Custom S-Type instruction to put immediate into reg file
    end else begin
      imme_value = 32'b0;
    end

    // FSM Output Control
    case (current_state)
      STATE_IDLE: begin
        next_instr = 1'b1;  // Ready for next op
        rs_addr_valid = 1'b0;
        rs1_rs2_rd = 15'b0;
        rs_store = 1'b0;
        rd2_imme_sel = 1'b1;
        rd_wr_en = 1'b0;
      end  // STATE_IDLE

      STATE_RS1_RS2_RD_IMME: begin
        next_instr = 1'b0;
        rs_addr_valid = 1'b1;  // make valid high because reg file should latch addr no matter what
        rs1_rs2_rd = {instr_reg[19:15], instr_reg[24:20], instr_reg[11:7]};  // All three addresses assigned
        if (decoded_instr_type == I_TYPE) begin
          rd2_imme_sel = 1'b0;
          rs_store = 1'b0;
          rd_wr_en = 1'b1;
        end else if (decoded_instr_type == S_TYPE) begin
          rs_store = 1'b1;
          rd2_imme_sel = 1'b0;
          rd_wr_en = 1'b0;
        end else begin
          rs_store = 1'b0;
          rd2_imme_sel = 1'b1;
          rd_wr_en = 1'b1;
        end
      end  // STATE_RS1_RS2_RD_IMME


      STATE_EXECUTE: begin
        next_instr = 1'b0;
        rs_addr_valid = 1'b0;
        rs1_rs2_rd = 15'b0;
        rs_store = 1'b0;
        rd2_imme_sel = rd2_imme_sel;
        if (decoded_instr_type == I_TYPE | decoded_instr_type == R_TYPE) begin
          rd_wr_en = 1'b1;
        end else begin
          rd_wr_en = 1'b0;
        end
      end //STATE_EXECUTE
      default: begin
        next_instr = 1'b1;
        rs_addr_valid = 1'b0;
        rs1_rs2_rd = 15'b0;
        rs_store = 1'b0;
        rd2_imme_sel = 1'b1;
        rd_wr_en = 1'b0;
      end //DEFAULT
    endcase //OUTPUT FSM
  end


endmodule
