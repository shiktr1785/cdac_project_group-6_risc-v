module instr_mem_v2 #(
    int DEPTH = 64
) (
    output logic [31:0] instr,
    output logic        instr_valid,
    input logic        next_instr,
    input logic [ 5:0] store_address,
    input logic [31:0] store_data,
    input logic        store_en,       //Use this to enable writes
    input logic        clk,
    input logic        reset_n
);

  logic [             31:0] instr_mem                          [DEPTH-1];  //memory block
  logic [$clog2(DEPTH)-1:0] current_address;  //current_address

  always_ff @(posedge clk or negedge reset_n) begin : read_mem_block
    if (!reset_n) begin
      current_address <= 6'b0;
      instr <= 32'b0;
      instr_valid <= 1'b0;
    end else begin
      if (store_en) begin  //Store is highest priority
        current_address <= store_address;
        instr_valid <= 1'b0;
      end else if (next_instr) begin
        instr_valid <= 1'b1;
        instr <= instr_mem[current_address];
        current_address <= current_address + 1'b1;
      end else begin
 	instr_valid <= 1'b0;
        instr <= instr;
        current_address <= current_address;
      end
    end
  end  // read_mem_block

  always_ff @(posedge clk) begin : write_mem_block
    if (store_en) begin
      instr_mem[store_address] <= store_data;
    end else begin
      instr_mem <= instr_mem;
    end
  end  //write_mem_block


endmodule  // instr_mem_v2
