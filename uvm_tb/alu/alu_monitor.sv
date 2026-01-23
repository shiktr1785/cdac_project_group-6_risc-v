`ifndef __ALU_MONITOR_SV
`define __ALU_MONITOR_SV

class alu_monitor #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends uvm_monitor;

    `uvm_component_param_utils(alu_monitor #(BUS_WIDTH, OPCODE_WIDTH))

    // Analysis port to send observed sequence items
    uvm_analysis_port #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)) ap;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    // Run phase
    virtual task run_phase(uvm_phase phase);
        alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;
        forever begin
            seq_item = alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)::type_id::create("seq_item");
            // Wait for a clock edge or some event to sample data
            @(posedge clk); // Assuming clk is accessible here
            // Sample DUT signals and populate seq_item
            seq_item.rs_data       = dut.rs_data;       // Replace with actual DUT signal
            seq_item.imme_rs       = dut.imme_rs;       // Replace with actual DUT signal
            seq_item.opcode        = dut.opcode;        // Replace with actual DUT signal
            seq_item.alu_data_out  = dut.alu_data_out;  // Replace with actual DUT signal
            seq_item.alu_data_valid= dut.alu_data_valid;// Replace with actual DUT signal

            // Send the sampled item through the analysis port
            ap.write(seq_item);
        end
    endtask : run_phase

endclass : alu_monitor

`endif
