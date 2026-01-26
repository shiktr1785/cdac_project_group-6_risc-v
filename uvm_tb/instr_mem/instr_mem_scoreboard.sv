`ifndef __INSTR_MEM_SCOREBOARD_SV
`define __INSTR_MEM_SCOREBOARD_SV

class instr_mem_scoreboard #(parameter BUS_WIDTH = 32) extends uvm_scoreboard;

    `uvm_component_utils(instr_mem_scoreboard#(BUS_WIDTH))

    // Analysis implementation to receive transactions from Monitor
    uvm_analysis_imp #(instr_mem_seq_item#(BUS_WIDTH), instr_mem_scoreboard#(BUS_WIDTH)) analysis_imp;

    // Reference Model Handle
    instr_mem_reference_model ref_model;

    function new(string name = "instr_mem_scoreboard", uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //create the reference model instance
        ref_model = instr_mem_reference_model::type_id::create("ref_model");
    endfunction : build_phase

    // Write function called by Monitor via Analysis Port
    function void write(instr_mem_seq_item#(BUS_WIDTH) item);
        bit [31:0] expected_data;
        
        //Get expected data from reference model
        expected_data = ref_model.get_expected_instr();

        //Compare actual and expected
        if (item.instruction !== expected_data) begin
            `uvm_error("SCB_MISMATCH", $sformatf("PC: %0d | Expected: 0x%0h | Actual: 0x%0h", ref_model.current_pc - 1, expected_data, item.instruction))
        end else begin
            `uvm_info("SCB_MATCH", $sformatf("PC: %0d | Data: 0x%0h Match", ref_model.current_pc - 1, item.instruction), UVM_HIGH)
        end
    endfunction : write

endclass : instr_mem_scoreboard

`endif

