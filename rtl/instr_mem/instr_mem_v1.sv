module instr_mem_v1 (
    output logic [31:0] instr,
    input  logic        next_op,
    input  logic        clock,
    input  logic        reset_n
);

    logic [31:0]  instr_mem [63];  //memory block
    logic [5:0]  current_address;  //current_address
  always_ff @(posedge clock or negedge reset_n) begin : mem_block
    if (!reset_n) begin
      current_address <= 6'b0;
      instr <= 32'b0;
    end else begin
      if (next_op) begin
        instr <= instr_mem[current_address];
        current_address <= current_address + 1'b1;
      end else begin
        instr <= instr;
        current_address <= current_address;
      end
    end  //mem_block
  end
  initial begin
    // 2. Loop through EVERY address
      for (int i = 0; i < 63; i++) begin

      // 3. Select instruction based on address modulo 3
      // This creates a repeating pattern: I -> R -> S -> I -> R ...
      case (i % 3)
        0: begin
          // I-TYPE (ADDI x1, x0, 10) - Opcode 0x13
          instr_mem[i] = 32'h00A00093;
        end

        1: begin
          // R-TYPE (ADD x2, x1, x1) - Opcode 0x33
          instr_mem[i] = 32'h00108133;
        end

        2: begin
          // S-TYPE (Custom STORE x2, 4(x1)) - Opcode 0x03
          instr_mem[i] = 32'h00208203;
        end
        default: begin
          instr_mem[i] = 32'h00108133;
        end
      endcase
    end
  end
endmodule  // instr_mem_v1

