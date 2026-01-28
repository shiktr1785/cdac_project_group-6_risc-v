`ifndef __INSTR_MEM_SEQUENCE_SV
`define __INSTR_MEM_SEQUENCE_SV

class instr_mem_sequence#(parameter BUS_WIDTH = 32) extends uvm_sequence #(instr_mem_seq_item#(BUS_WIDTH));

    `uvm_object_utils(instr_mem_sequence#(BUS_WIDTH))

    // Memory Depth
    localparam int MEM_DEPTH = 64;
    protected int pc; //So that it canbe inherited by subclasses
    
    function new(string name = "instr_mem_sequence");
        super.new(name);
        pc = 0;
    endfunction: new

    virtual task body();
        instr_mem_seq_item#(BUS_WIDTH) req;
        
        `uvm_info("SEQ", "SEQ START", UVM_LOW);

        repeat(MEM_DEPTH) begin
            req = instr_mem_seq_item#(BUS_WIDTH)::type_id::create("req");
            start_item(req);
            
            req.current_pc=pc;
            req.next_instr=(pc<MEM_DEPTH)?1:0;// Set next_instr based on boundary
            
            finish_item(req);
            `uvm_info("SEQ_ITEM", $sformatf("Instruction at PC=%0d is %0h", pc, req.instr), UVM_LOW);
            pc = pc + 1;
        end
        
        `uvm_info("SEQ", "SEQ END", UVM_LOW);
    endtask: body

endclass: instr_mem_sequence

`endif

//EXTENDED OUT OF BOUNDS SEQUENCE

`ifndef __OOB_INSTR_MEM_SEQUENCE_SV
`define __OOB_INSTR_MEM_SEQUENCE_SV

class oob_instr_mem_sequence#(parameter BUS_WIDTH = 32) extends instr_mem_sequence#(BUS_WIDTH);

    `uvm_object_utils(oob_instr_mem_sequence#(BUS_WIDTH))

    function new(string name = "oob_instr_mem_sequence");
        super.new(name);
    endfunction

    virtual task body();
        instr_mem_seq_item#(BUS_WIDTH) req;
        
        super.body();  // Run in-bounds sequence first
        
        `uvm_info("OOB_SEQ", "OOB SEQ CROSSING BOUNDS", UVM_NONE)

        repeat(20) begin
            req = instr_mem_seq_item#(BUS_WIDTH)::type_id::create("req");
            start_item(req);
            
            req.current_pc = pc;
            req.next_instr = 1; // Force next_instr even beyond bounds
            
            finish_item(req);
            `uvm_info("OOB_SEQ_ITEM", $sformatf("Instruction at PC=%0d is %0h", pc, req.instr), UVM_LOW);
            pc = pc + 1;
        end
        
        `uvm_info("OOB_SEQ", "VIOLATION COMPLETE", UVM_LOW);
    endtask

endclass: oob_instr_mem_sequence

`endif

