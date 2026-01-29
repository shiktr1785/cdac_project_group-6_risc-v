`ifndef __INSTR_MEM_SCOREBOARD_SV
`define __INSTR_MEM_SCOREBOARD_SV

class instr_mem_scoreboard#(parameter BUS_WIDTH = 32) extends uvm_scoreboard;

    `uvm_component_utils(instr_mem_scoreboard#(BUS_WIDTH))

    uvm_analysis_imp#(instr_mem_seq_item#(BUS_WIDTH), instr_mem_scoreboard#(BUS_WIDTH)) analysis_imp;

    bit [31:0] ref_mem [63:0];
    int        shadow_pc;
    int        pass_count;
    int        fail_count;

    function new(string name = "instr_mem_scoreboard", uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
        shadow_pc = 0;
        pass_count = 0;
        fail_count = 0;
        `uvm_info(get_name(), "New", UVM_HIGH)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Build Phase", UVM_HIGH)
        // Load File into Memory
        $readmemh("instr_mem_init.mem", ref_mem);
        `uvm_info("SCB", "Reference memory loaded successfully", UVM_MEDIUM)
    endfunction

    function void write(instr_mem_seq_item#(BUS_WIDTH) item);
        bit [31:0] expected_data;
        expected_data = ref_mem[shadow_pc];
        if (item.instr !== expected_data) begin
            fail_count++;
            `uvm_error("SCB_MISMATCH", $sformatf("PC=%0d | Exp: 0x%08h | Act: 0x%08h", shadow_pc, expected_data, item.instr))
        end else begin
            pass_count++;
            `uvm_info("SCB_MATCH", $sformatf("PC=%0d | Match: 0x%08h", shadow_pc, item.instr), UVM_HIGH)
        end
        // Increment shadow pc
        shadow_pc=(shadow_pc<63)?shadow_pc+1:0;
    endfunction

    // Number of tests passed
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB_REPORT", $sformatf("Passed: %0d | Failed: %0d", pass_count, fail_count), UVM_LOW)
        
        if (fail_count==0&&pass_count>0) begin
            `uvm_info("SCB_FINAL", "*** ALL TESTS PASSED ***", UVM_NONE)
        end else if (pass_count==0) begin
            `uvm_warning("SCB_FINAL", "No transactions checked!")
        end else begin
            `uvm_error("SCB_FINAL", "*** SOME TESTS FAILED ***")
        end
    endfunction

endclass: instr_mem_scoreboard

`endif  