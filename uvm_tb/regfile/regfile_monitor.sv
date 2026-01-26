`ifndef __REGFILE_MONITOR_SV
`define __REGFILE_MONITOR_SV

class regfile_monitor #(int BUS_WIDTH = 32, int ADDR_WIDTH = 15) extends uvm_monitor;

    `uvm_component_param_utils(regfile_monitor #(BUS_WIDTH, ADDR_WIDTH))

    // Virtual interface
    virtual regfile_if #(BUS_WIDTH, ADDR_WIDTH) regfile_vif;

    // Analysis port to send observed sequence items
    uvm_analysis_port #(regfile_seq_item #(ADDR_WIDTH, BUS_WIDTH)) ap;

    // Cover group for monitoring coverage

    covergroup regfile_monitor_cg;

        // Coverpoint for rs_addr_valid
        coverpoint regfile_vif.rs_addr_valid {
            bins valid = {1};
            bins invalid = {0};
        }

        // Coverpoint for rd_wr_en
        coverpoint regfile_vif.rd_wr_en {
            bins read = {0};
            bins write = {1};
        }

        // 1. Coverage for rd [14:10]
        cp_rd: coverpoint regfile_vif.rs1_rs2_rd[14:10] {
            bins zero       = {5'd0};
            bins first      = {5'd1};
            bins mid_low    = {5'd15};
            bins mid_high   = {5'd16};
            bins near_last  = {5'd30};
            bins last       = {5'd31};
            bins others     = {[2:14], [17:29]}; // Everything else
        }

        // 2. Coverage for rs2 [9:5]
        cp_rs2: coverpoint regfile_vif.rs1_rs2_rd[9:5] {
            bins zero       = {5'd0};
            bins last       = {5'd31};
            bins mid_range  = {[1:30]};
        }

        // 3. Coverage for rs1 [4:0]
        cp_rs1: coverpoint regfile_vif.rs1_rs2_rd[4:0] {
            bins zero       = {5'd0};
            bins last       = {5'd31};
            bins mid_range  = {[1:30]};
        }

    endgroup : regfile_monitor_cg

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Run phase
    virtual task run_phase(uvm_phase phase);
        regfile_seq_item #(ADDR_WIDTH, BUS_WIDTH) seq_item;
        forever begin
            seq_item = regfile_seq_item #(ADDR_WIDTH, BUS_WIDTH)::type_id::create("seq_item");
            // Wait for a clock edge or some event to sample data
            @(posedge regfile_vif.clk);
            // Sample DUT signals and populate seq_item
            seq_item.rs_store       = regfile_vif.rs_store;       // Replace with actual DUT signal
            seq_item.rs_addr_valid  = regfile_vif.rs_addr_valid;  // Replace with actual DUT signal
            seq_item.imme_data      = regfile_vif.imme_data;      // Replace with actual DUT signal 
            seq_item.rd_wr_en       = regfile_vif.rd_wr_en;      // Replace with actual DUT signal  
            seq_item.rs1_rs2_rd     = regfile_vif.rs1_rs2_rd;     // Replace with actual DUT signal
            seq_item.alu_data_valid = regfile_vif.alu_data_valid; // Replace with actual DUT signal
            seq_item.alu_data_out   = regfile_vif.alu_data_out;   // Replace with actual DUT signal
            seq_item.op_done        = regfile_vif.op_done;        // Replace with actual DUT signal
            seq_item.rs_data_mux    = regfile_vif.rs_data_mux;    // Replace with actual DUT signal
            seq_item.rs_data        = regfile_vif.rs_data;        // Replace with actual DUT signal

            // Send the sampled item through the analysis port
            ap.write(seq_item);
        end
        `uvm_info(get_name(), "Run_phase", UVM_HIGH)
    endtask : run_phase
endclass : regfile_monitor

`endif
