`ifndef __INSTR_MEM_SEQ_ITEM_SV
`define __INSTR_MEM_SEQ_ITEM_SV

<<<<<<< Updated upstream
class instr_mem_seq_item extends uvm_sequence_item;
    
    //Factory Registration
    `uvm_object_utils(instr_mem_seq_item)
=======
class instr_mem_seq_item #(
    parameter integer ADDR_WIDTH = 5, parameter integer BUS_WIDTH = 32
    ) 
    extends uvm_sequence_item;

    `uvm_object_utils(instr_mem_seq_item #(ADDR_WIDTH, BUS_WIDTH))
    
    // Data members
    // 1 - OP_done,push out the instruction; 0 - Stop instruction 
    rand bit                    next_instr;
         bit [BUS_WIDTH-1:0]    instruction;

>>>>>>> Stashed changes

    // Data members
    // 1 - OP_done,push out the instruction; 0 - Stop instruction 
    rand bit        next_instr;
         bit [31:0] instruction;
     
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

<<<<<<< Updated upstream
    function void print();
        //Prints the status of the next_instruction
        `uvm_info("next_instr_status", $sformatf("next_instr = %0b", next_instr), UVM_LOW)  
        `uvm_info("instruction_status", $sformatf("instruction = %0b", instruction), UVM_LOW)
=======
    function void display();
        //Prints the status of the next_op
        `uvm_info("next_op_status", $sformatf("next_op = %0b", next_instr), UVM_LOW)  
>>>>>>> Stashed changes
    endfunction

endclass:instr_mem_seq_item
    
`endif

