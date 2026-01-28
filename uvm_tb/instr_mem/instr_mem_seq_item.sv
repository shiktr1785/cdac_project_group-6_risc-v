`ifndef __INSTR_MEM_SEQ_ITEM_SV
`define __INSTR_MEM_SEQ_ITEM_SV

class instr_mem_seq_item#(parameter BUS_WIDTH = 32) extends uvm_sequence_item;
    
    //Factory Registration
    `uvm_object_utils(instr_mem_seq_item#(BUS_WIDTH))
    // Data members
    bit                    next_instr;
    bit [BUS_WIDTH-1:0]    instr;
    bit                    instr_valid;

    //To track current PC
    int current_pc;

    //Constructor
    function new(string name = "instr_mem_seq_item");
        super.new(name);
    endfunction
    
    function void display();
        //Prints the status of the next_instr
        `uvm_info("next_instr_status", $sformatf("next_instr = %0b", next_instr), UVM_LOW)  
    endfunction

endclass:instr_mem_seq_item
    
`endif