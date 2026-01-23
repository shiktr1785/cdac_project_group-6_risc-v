module alu (
    input  logic [31:0] rs_data,       
    input  logic [31:0] imme_rs,       
    input  logic [3:0]  opcode, 
    output logic [31:0] alu_data_out,  
  	output logic        alu_data_valid
);

  typedef enum logic [3:0] {
    ADD  = 4'b0000,
    SUB  = 4'b1000,
    SLL  = 4'b0001,
    SLT  = 4'b0010,
    SLTU = 4'b0011,
    XOR  = 4'b0100,
    SRL  = 4'b0101,
    SRA  = 4'b1101,
    OR   = 4'b0110,
    AND  = 4'b0111
} alu_op_t;
  
  	assign alu_data_valid = 1'b1;

    always_comb begin
        case (opcode)
            ADD:  alu_data_out = rs_data + imme_rs;
            SUB:  alu_data_out = rs_data - imme_rs;
            SLL:  alu_data_out = rs_data << imme_rs[4:0];
            SLT:  alu_data_out = ($signed (rs_data) < $signed (imme_rs)) ? 32'd1 : 32'd0;
            SLTU: alu_data_out = (rs_data < imme_rs) ? 32'd1 : 32'd0;
            SRL:  alu_data_out = rs_data >> imme_rs[4:0];
            SRA:  alu_data_out = $signed (rs_data) >>> imme_rs[4:0];
            AND:  alu_data_out = rs_data & imme_rs;
          	OR:   alu_data_out = rs_data | imme_rs;
          	XOR:  alu_data_out = rs_data ^ imme_rs;
            
            default: begin alu_data_out = 32'b0; 
            end
        endcase
    end
endmodule
