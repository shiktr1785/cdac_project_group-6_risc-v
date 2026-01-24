`ifndef __ALU_MONITOR_SV
`define __ALU_MONITOR_SV

class alu_monitor #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends uvm_monitor;

    `uvm_component_param_utils(alu_monitor #(BUS_WIDTH, OPCODE_WIDTH))

    // Virtual interface
    virtual alu_if #(BUS_WIDTH, OPCODE_WIDTH) alu_vif;

    // Analysis port to send observed sequence items
    uvm_analysis_port #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH)) ap;

    // Cover group for monitoring coverage

    covergroup alu_monitor_cg;

        // Coverpoint for opcode
        coverpoint alu_vif.opcode {
            bins valid_opcodes = {4'b0000, 4'b1000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1101, 4'b0110 ,4'b0111};
            bins illegal_opcodes = default;
        }

        // Coverpoint for rs_data
        coverpoint alu_vif.rs_data {
            bins boundary_values = {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
            bins random_values = default;
        }

        // Coverpoint for imme_rs
        coverpoint alu_vif.imme_rs {
            bins boundary_values = {32'h00000000,  32'h00000001,  32'hFFFFFFFF,  32'h7FFFFFFF,  32'h80000000, 32'hAAAAAAAA, 32'h55555555};
            bins random_values = default;
        }


    endgroup : alu_monitor_cg

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
            @(posedge alu_vif.clk);
            // Sample DUT signals and populate seq_item
            seq_item.rs_data       = alu_vif.rs_data;       // Replace with actual DUT signal
            seq_item.imme_rs       = alu_vif.imme_rs;       // Replace with actual DUT signal
            seq_item.opcode        = alu_vif.opcode;        // Replace with actual DUT signal
            seq_item.alu_data_out  = alu_vif.alu_data_out;  // Replace with actual DUT signal
            seq_item.alu_data_valid= alu_vif.alu_data_valid;// Replace with actual DUT signal

            // Send the sampled item through the analysis port
            ap.write(seq_item);
        end
    endtask : run_phase

endclass : alu_monitor

`endif
