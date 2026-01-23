`ifndef __INSTR_MEM_SEQ_ITEM_SV
`define __INSTR_MEM_SEQ_ITEM_SV

class instr_mem_seq_item #(
    parameter integer BUS_WIDTH = 32
    ) extends uvm_sequence_item;
    
    //Factory Registration
    `uvm_object_utils(instr_mem_seq_item#(BUS_WIDTH))
    // Data members
    // 1 - OP_done,push out the instruction; 0 - Stop instruction 
    rand bit                 next_instr;
         bit [BUS_WIDTH-1:0] instruction;

    //To track current PC
     int current_pc;

     //Constraints

     //Constraint IOB(IN of Bounds) respect the boundary within MEM_DEPTH
    constraint IOB_c { 
        (current_pc<64)-> next_instr==1;
        (current_pc>=64)-> next_instr==0;
    }  

    //Constraint OOB(Out of Bounds) to cross the boundary of MEM_DEPTH
    constraint OOB_c { 
    (current_pc>=64)-> next_instr==1;
    }

    //Constructor
    function new(string name = "instr_mem_seq_item");
        super.new(name);
        IOB_c.constraint_mode(1); //Enable IOB constraint by default
        OOB_c.constraint_mode(0); //Disable OOB constraint by default
    endfunction
    
    function void display();
        //Prints the status of the next_instr
        `uvm_info("next_instr_status", $sformatf("next_instr = %0b", next_instr), UVM_LOW)  
    endfunction

endclass:instr_mem_seq_item
    
`endif


