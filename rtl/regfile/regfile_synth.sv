module regfile (
    input  logic        clk,

    // Decoder Interface
    input  logic        rs_addr_valid,  // Valid signal for address latching
    input  logic [14:0] rs1_rs2_rd,     // Packed: {rs1[4:0], rs2[4:0], rd[4:0]}
    
    // Write Controls
    input  logic        rd_wr_en,       // Enable for ALU results
    input  logic        rs_store,       // Immediate Store Enable
    input  logic [31:0] imme_data,      // Immediate data to store

    // Data Interface
    input  logic [31:0] alu_data_out,   // Data from ALU
  	output logic [31:0] rs_data,        // Read Data 1
    output logic [31:0] rs_data_mux,    // Read Data 2
    
    // Status Output
    output logic        op_done         // Ack to Decoder
  	  
  	
);

  	// 32 x 32-bit Register Array
    logic [31:0] reg_file [31:0];

    // Internal Address Registers (Latches)
    logic [4:0]  addr_rs1;
    logic [4:0]  addr_rs2;
    logic [4:0]  addr_rd;
  
    
    always_ff @(posedge clk) begin
      
            // Default: Clear op_done every cycle unless we set it
            op_done <= 1'b0;

            // 1. Decode / Address Latch Phase
            if (rs_addr_valid) begin
                addr_rs1 <= rs1_rs2_rd[14:10]; 
                addr_rs2 <= rs1_rs2_rd[9:5];
                addr_rd  <= rs1_rs2_rd[4:0];

                // Immediate Write
                if (rs_store) begin
                    if (rs1_rs2_rd[4:0] != 5'b0) begin
                        reg_file[rs1_rs2_rd[4:0]] <= imme_data;
                    end
                    // Signal DONE so Decoder exits 'EXECUTE' state next cycle
                    op_done <= 1'b1; 
                end
            end

            // 2. Write Back Phase (Standard ALU Write)
            else if (rd_wr_en) begin
                if (addr_rd != 5'b0) begin
                    reg_file[addr_rd] <= alu_data_out;
                end
                // Signal DONE to confirm write finished
                op_done <= 1'b1;
            end
    end

    // Read Logic
    assign rs_data = (addr_rs1 == 5'b0) ? 32'b0 : reg_file[addr_rs1];
    assign rs_data_mux = (addr_rs2 == 5'b0) ? 32'b0 : reg_file[addr_rs2];
    
    initial begin 
    	$readmemh("reg_init.mem",reg_file);
    end
endmodule 


