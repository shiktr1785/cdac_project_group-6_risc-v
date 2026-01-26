`ifndef __ALU_DRIVER_SV
`define __ALU_DRIVER_SV

class alu_driver #(int BUS_WIDTH = 32, int OPCODE_WIDTH = 4) extends uvm_driver #(alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH));

    `uvm_component_param_utils(alu_driver #(BUS_WIDTH, OPCODE_WIDTH));

    // Virtual interface
    virtual alu_if #(BUS_WIDTH, OPCODE_WIDTH) alu_vif;

    // Constructor

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Build phase

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_if #(BUS_WIDTH, OPCODE_WIDTH))::get(this, "", "alu_vif", alu_vif)) begin
            `uvm_fatal("ALU_DRV_BLD", "Virtual interface alu_vif not found")
        end
        `uvm_info(get_name(), "Build phase", UVM_HIGH)
    endfunction

    // Main run phase

    task run_phase(uvm_phase phase);
        alu_sequence_item #(BUS_WIDTH, OPCODE_WIDTH) seq_item;

        // Best practice: Initialize interface to idle state
        alu_vif.rs_data <= 0;
        alu_vif.imme_rs <= 0;
        alu_vif.opcode  <= 0;

        forever begin
            // Get the next sequence item
            seq_item = null;
            seq_item_port.get_next_item(seq_item);

            // Drive the inputs to the DUT
            alu_vif.rs_data      <= seq_item.rs_data;
            alu_vif.imme_rs      <= seq_item.imme_rs;
            alu_vif.opcode       <= seq_item.opcode;

            // Wait for a clock cycle
            @(posedge alu_vif.clk);

            // Capture the outputs from the DUT
            seq_item.alu_data_out   = alu_vif.alu_data_out;
            seq_item.alu_data_valid = alu_vif.alu_data_valid;

            // Indicate that the item is done
            seq_item_port.item_done();
        end
        `uvm_info(get_name(), "Run phase", UVM_HIGH)
    endtask : run_phase

endclass : alu_driver

`endif
