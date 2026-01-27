`ifndef __REGFILE_SCOREBOARD_SV
`define __REGFILE_SCOREBOARD_SV

class regfile_scoreboard #(parameter BUS_WIDTH = 32, parameter ADDR_WIDTH = 15) extends uvm_scoreboard;

    `uvm_component_param_utils(regfile_scoreboard #(BUS_WIDTH, ADDR_WIDTH))

    // Analysis implementation to receive transactions from Monitor
    uvm_analysis_imp #(regfile_seq_item#(BUS_WIDTH, ADDR_WIDTH), regfile_scoreboard#(BUS_WIDTH, ADDR_WIDTH)) analysis_imp;

    // Reference Model Handle
    regfile_reference_model #(BUS_WIDTH, ADDR_WIDTH) ref_model;

    function new(string name = "regfile_scoreboard", uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //create the reference model instance
        ref_model = regfile_reference_model#(BUS_WIDTH, ADDR_WIDTH)::type_id::create("ref_model");
    endfunction : build_phase

    // Write function called by Monitor via Analysis Port
    function void write(regfile_seq_item#(BUS_WIDTH, ADDR_WIDTH) item);
        bit [BUS_WIDTH-1:0] expected_data;
        
        //Get expected data from reference model
        expected_data = ref_model.get_expected_data(item.addr, item.is_read);

        //Compare actual and expected
        if (item.data !== expected_data) begin
            `uvm_error("SCB_MISMATCH", $sformatf("| Expected: 0x%0h | Actual: 0x%0h",expected_data, item.data))
        end else begin
            `uvm_info("SCB_MATCH", $sformatf("| Data: 0x%0h Match",item.data), UVM_HIGH)
        end
    endfunction : write

endclass : regfile_scoreboard


`endif
