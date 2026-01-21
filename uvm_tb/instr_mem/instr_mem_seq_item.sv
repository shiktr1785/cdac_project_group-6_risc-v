`ifndef __INSTR_MEM_SEQ_ITEM_SV
`define __INSTR_MEM_SEQ_ITEM_SV

class instr_mem_seq_item #(integer ADDR_WIDTH = 5, BUS_WIDTH = 32) extends uvm_sequence_item;
    
    // Data members

    // 1 - OP_done,push out the instruction; 0 - Stop instruction 
    rand bit next_op;

    `uvm_object_utils(instr_mem_seq_item)

    // Constructor
    function new(string name = "instr_mem_seq_item");
        super.new(name);
    endfunction

    function void print();
        //Prints the status of the next_op
        `uvm_info("next_op_status", $sformatf("next_op = %0b", next_op), UVM_LOW)  
    endfunction
endclass:instr_mem_seq_item
    
`endif
