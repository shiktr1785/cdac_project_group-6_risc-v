module decoder_auto (
    // For alu
    output logic [ 3:0] alu_opcode,        // {funct7,funct3}
    output logic [31:0] alu_imme,          //Sign extended output immediate data
    output logic        alu_imme_rs2_sel,  //Selecting between immediate and rs2 data in mux,
                                           //  0 imme, 1 is rs2
    // For reg file
    output logic [ 4:0] rs_addr,
    output logic [ 4:0] rd_addr,
    output logic        rs_valid,          //For controlling address to Reg File
    output logic        rs_sel,
    output logic        rs_store,          //For load and store
    // For instr_mem
    output logic        next_op,
    // Inputs
    input  logic [31:0] instr,
    input  logic        instr_valid,
    input  logic        alu_op_done,       // Ack from ALU
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
    STATE_RS1,     // Read first operand
    STATE_RS2_IMME,     // Read second operand and switch between IMME and RS2 (if R-TYPE)
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
          next_state = STATE_RS1;
        end
      end

      STATE_RS1: begin
        // After reading RS1 we go to RS2_IMME where we switch between RS2 and IMME
        next_state = STATE_RS2_IMME;
      end

      STATE_RS2_IMME: begin
        // R-Type always moves to Execute after RS2
        next_state = STATE_EXECUTE;
      end

      STATE_EXECUTE: begin
        // Handshake done, go back to IDLE
        if (alu_op_done) begin
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

    rd_addr = instr_reg[11:7];  //rd is valid for any instruction and
                                //is point to point so it is outside
    // ALU Opcode extraction
    if (decoded_instr_type == UDEF) begin
      alu_opcode = 4'b0;
    end else begin
      alu_opcode = {instr_reg[30], instr_reg[14:12]};
    end

    // Immediate generation
    if (decoded_instr_type == I_TYPE) begin
      alu_imme = {{21{instr_reg[31]}}, instr_reg[30:20]};
    end else if (decoded_instr_type == S_TYPE) begin
      alu_imme = {{21{instr_reg[31]}}, instr_reg[30:25], instr_reg[11:7]};
      // Note: S-Type immediate split is different in standard RISC-V
      // but kept close to your logic logic for simplicity.
    end else begin
      alu_imme = 32'b0;
    end

    // FSM Output Control
    case (current_state)
      STATE_IDLE: begin
        next_op = 1'b1;  // Ready for next op
        rs_valid = 1'b0;
        rs_addr = 5'b0;
        rs_sel = 1'b0;
        rs_store = 1'b0;
        alu_imme_rs2_sel = 1'b0;
      end  // STATE_IDLE

      STATE_RS1: begin
        next_op  = 1'b0;
        rs_valid = 1'b1;
        rs_sel   = 1'b0;  // Select RS1
        rs_addr  = instr_reg[19:15];  // rs1 field
        if (decoded_instr_type == S_TYPE) begin
          rs_store = 1'b1;
          alu_imme_rs2_sel = 1'b1;
        end else begin
          rs_store = 1'b0;
          alu_imme_rs2_sel = 1'b0;
        end
      end  // STATE_RS1

      STATE_RS2_IMME: begin
        next_op  = 1'b0;
        rs_valid = 1'b1;
        if (decoded_instr_type == R_TYPE) begin
          alu_imme_rs2_sel = 1'b0;
          rs_sel = 1'b1;
          rs_addr = instr_reg[24:20];
          rs_store = 1'b0;
        end else if (decoded_instr_type == I_TYPE) begin
          rs_addr = 5'b0;
          rs_sel = 1'b0;
          alu_imme_rs2_sel = 1'b1;
          rs_store = 1'b0;
        end else begin
          rs_sel = 1'b0;
          alu_imme_rs2_sel = 1'b1;
          rs_addr = 5'b0;
          rs_store = 1'b1;
        end
      end  // case: STATE_RS2_IMME


      STATE_EXECUTE: begin
        next_op = 1'b0;  // Ready for next op
        rs_valid = 1'b0;
        rs_addr = 5'b0;
        rs_sel = 1'b0;
        rs_store = 1'b0;
        alu_imme_rs2_sel = 1'b0;
      end
      default: begin
        next_op = 1'b1;
        rs_valid = 1'b0;
        rs_sel = 1'b0;
        rs_addr = 5'b0;
        rs_store = 1'b0;
        alu_imme_rs2_sel = 1'b0;
      end
    endcase
  end


endmodule
