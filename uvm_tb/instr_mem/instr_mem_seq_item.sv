    `ifndef __INSTR_MEM_SEQ_ITEM_SV
    `define __INSTR_MEM_SEQ_ITEM_SV

    class instr_mem_seq_item#(
        parameter ADDR=6,
        parameter BUS_WIDTH=32
    ) extends uvm_sequence_item;
        
        //Factory Registration
        `uvm_object_utils(instr_mem_seq_item#(ADDR, BUS_WIDTH))
        local int DEPTH=64;
        // Data members
        // 1 - next_instr,push out the instruction; 0 - Stop instruction 
        rand bit                    next_instr;
        
        rand bit                    store_en;
        rand bit [ADDR-1:0]         store_address; 
        rand bit [BUS_WIDTH-1:0]    store_data;

        // Output members
            bit [BUS_WIDTH-1:0]    instruction;
            bit                    instr_valid;

        //To track current PC
        int current_pc;

        //Constraints

        //Constraint IOB(IN of Bounds) respect the boundary within MEM_DEPTH
        constraint IOB_c { 
            (current_pc < DEPTH)-> next_instr==1;
            (current_pc >= DEPTH)-> next_instr==0;
        }  

        //Constraint OOB(Out of Bounds) to cross the boundary of MEM_DEPTH
        constraint OOB_c { 
            (current_pc >= DEPTH)-> next_instr==1;
        }

        //Constructor
        function new(string name = "instr_mem_seq_item");
            super.new(name);
            IOB_c.constraint_mode(1); //Enable IOB constraint by default
            OOB_c.constraint_mode(0); //Disable OOB constraint by default
        endfunction
        
        function void display();
            //Prints the status of the item
            `uvm_info("seq_item_status", $sformatf("next_instr = %0b, store_en = %0b, addr = %0h, data = %0h", next_instr, store_en, store_address, store_data), UVM_LOW)  
        endfunction

    endclass:instr_mem_seq_item
        
    `endif