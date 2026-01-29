`ifndef DECODER_SEQUENCE_ITEM_SV
`define DECODER_SEQUENCE_ITEM_SV

class decoder_sequence_item #(
    parameter integer ADDR_WIDTH = 15,
    parameter integer BUS_WIDTH = 32,
    parameter integer OPCODE_WIDTH = 4
) extends uvm_sequence_item;

    `uvm_object_utils(decoder_sequence_item #(ADDR_WIDTH, BUS_WIDTH, OPCODE_WIDTH));

   
    
    // Inputs 
    rand logic [BUS_WIDTH - 1 : 0] instr;
    rand logic                     instr_valid;
    rand logic                     next_instr;  // Input from memory/control

    // Outputs 
    logic [BUS_WIDTH - 1 : 0]      imme_data;
    logic [OPCODE_WIDTH - 1 : 0]   opcode;
    logic [ADDR_WIDTH - 1 : 0]     rs1_rs2_rd;
    logic                          rs_addr_valid;
    logic                          rd_wr_en;
    logic                          rs_store;
    logic                          rd2_imme_sel;
    logic                          op_done;

    
    // 1. BASE CONSTRAINTS (Always Active)
    constraint c_basic {
        instr_valid == 1'b1;
    }

    // 2. LEGAL Constraint Block
    constraint c_legal {
        instr[6:0] inside {
            7'b0110011, // R-TYPE (Arithmetic)
            7'b0010011, // I-TYPE (Arithmetic Imm)
            7'b0000011, // I-TYPE (Load)
            7'b0100011  // S-TYPE (Store)
        };
    }

    // 3. ILLEGAL Constraint Block
    constraint c_illegal {
        !(instr[6:0] inside {7'b0110011, 7'b0010011, 7'b0000011, 7'b0100011});
       
        // forcing it to check the opcode bits instead).
        instr[1:0] == 2'b11;
    }

    // 4. MIXED Constraint Block
    constraint c_mixed {
        instr[6:0] dist {
            // Legal Opcodes (Total 80%)
            7'b0110011 := 20, 
            7'b0010011 := 20, 
            7'b0000011 := 20, 
            7'b0100011 := 20,
            
            // Illegal Opcodes (Total 20%)
            [7'b0000000:7'b1111111] := 20 
        };
    }

    // Constructor
    function new(string name = "decoder_sequence_item");
        super.new(name);
    endfunction
  
  
    function void display(string name = "decoder_sequence_item");
        $display("----------%s----------", name);
    endfunction: name

endclass : decoder_sequence_item

`endif
