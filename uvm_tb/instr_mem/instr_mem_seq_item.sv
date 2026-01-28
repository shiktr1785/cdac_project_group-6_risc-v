`ifndef __INSTR_MEM_SEQ_ITEM_SV
`define __INSTR_MEM_SEQ_ITEM_SV

class instr_mem_seq_item#(parameter BUS_WIDTH = 32) extends uvm_sequence_item;
    
    //Factory Registration
    `uvm_object_utils(instr_mem_seq_item#(BUS_WIDTH))
    
    // Data members
    bit                        next_instr;     // To fetch next instruction
    bit                        reset_n;        // Active-low reset signal
    bit [BUS_WIDTH-1:0]        instr;          // Instruction from memory
    bit                        instr_valid;    // Valid signal for instruction
    
    //To track current PC
    int current_pc;

    //Constructor
    function new(string name = "instr_mem_seq_item");
        super.new(name);
    endfunction
    
    function void display();
        `uvm_info("SEQ_ITEM_STATUS", $sformatf("reset_n=%0b, next_instr=%0b, instr=0x%0h, instr_valid=%0b, PC=%0d", 
                  reset_n, next_instr, instr, instr_valid, current_pc), UVM_LOW)
    endfunction

endclass: instr_mem_seq_item
    
`endif