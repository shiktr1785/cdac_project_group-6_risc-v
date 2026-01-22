`ifndef __INSTR_MEM_SEQUENCE_SV
`define __INSTR_MEM_SEQUENCE_SV

<<<<<<< Updated upstream
class instr_mem_sequence extends uvm_sequence #(instr_mem_seq_item);

    `uvm_object_utils(instr_mem_sequence)

    // Memory Depth
    localparam int MEM_DEPTH = 64;
    protected int pc;
    function new(string name = "instr_mem_sequence");
        super.new(name);
        pc=0;
    endfunction: new

    virtual task body();
        instr_mem_seq_item req;
        //Create tracker for internal address tracking
        `uvm_info("SEQ","SEQ START",UVM_LOW);

        //Repeat it MEM_DEPTH times
        repeat(MEM_DEPTH) begin
        req = instr_mem_seq_item::type_id::create("req");
        start_item(req);
        
        req.current_pc = pc;

        req.IOB_c.constraint_mode(1); //Enable IOB constraint
        req.OOB_c.constraint_mode(0); //Disable OOB constraint

        if(!req.randomize()) 
            `uvm_error("SEQ","Randomization failed");
   
        finish_item(req);
        `uvm_info("SEQ ITEM", $sformatf("Instruction at PC=%0d is %0h", pc, req.instruction), UVM_LOW);
        pc=pc+1;
        end
        `uvm_info("SEQ", "SEQ END", UVM_LOW);
    endtask: body

endclass: instr_mem_sequence

`endif

//EXTENDED OUT OF BOUNDS SEQUENCE

`ifndef __OOB_INSTR_MEM_SEQUENCE_SV
`define __OOB_INSTR_MEM_SEQUENCE_SV

class oob_instr_mem_sequence extends instr_mem_sequence;

    `uvm_object_utils(oob_instr_mem_sequence)

    function new(string name = "oob_instr_mem_sequence");
        super.new(name);
    endfunction: new

    virtual task body();
        instr_mem_seq_item req;
        super.body();  // Call the base class body to complete in-bounds sequence first

        `uvm_info("OOB_SEQ","OOB SEQ CROSSING BOUNDS",UVM_NONE)

        //Repeat it 20 times
        repeat(20) begin
        req = instr_mem_seq_item::type_id::create("req");
        start_item(req);
        
        req.IOB_c.constraint_mode(0);  // Turn off safety
        req.OOB_c.constraint_mode(1); // Turn on danger
        finish_item(req);
        `uvm_info("OOB SEQ ITEM VIOLATED", $sformatf("Instruction at PC=%0d is %0h", pc, req.instruction), UVM_LOW);
       
        pc=pc+1;
        end
        `uvm_info("OOB SEQ","VIOLATION COMPLETE",UVM_LOW)
    endtask

endclass: oob_instr_mem_sequence

`endif




=======

class instr_mem_sequence  extends uvm_sequence#(instr_mem_seq_item);
    `uvm_object_param_utils(instr_mem_sequence)

    function new(string name = "instr_mem_sequence");
        super.new(name);
    endfunction

    virtual task body();
        instr_mem_seq_item next_seq; 
        `uvm_do(next_seq)             //next_seq is created , randomized and sent to the driver
    endtask
endclass: instr_mem_sequence

`endif
>>>>>>> Stashed changes
