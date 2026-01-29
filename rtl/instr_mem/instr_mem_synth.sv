
module instr_mem_synth (
    output logic [31:0] instr,
    output logic        instr_valid,
    input  logic        next_instr,
    input  logic        clk,
    input  logic        reset_n
);

  (* keep = "true" *)logic [31:0] instr_mem [63:0]; 
  logic [5:0]  current_address;

  always_ff @(posedge clk or negedge reset_n) begin : mem_block
    if (!reset_n) begin
      current_address <= 6'b0;
      instr           <= 32'b0;
      instr_valid     <= 1'b0;
    end else begin
         if (next_instr) begin
          instr_valid     <= 1'b1;
          instr           <= instr_mem[current_address];
          current_address <= current_address + 1'b1;
        end else begin
          instr_valid     <= 1'b0;
          instr <= instr;
          current_address <= current_address;
        end
    end
  end

  initial begin
    $readmemh("instr_mem_init.mem",instr_mem);
  end

endmodule

