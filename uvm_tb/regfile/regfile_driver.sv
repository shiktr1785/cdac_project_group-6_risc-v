`ifndef __REGFILE_DRIVER_SV
`define __REGFILE_DRIVER_SV

class regfile_driver #(int BUS_WIDTH=32, int ADDR_WIDTH=15) extends uvm_driver #(regfile_seq_item #(ADDR_WIDTH,BUS_WIDTH));

    `uvm_component_param_utils(regfile_driver #(BUS_WIDTH, ADDR_WIDTH));

    // Virtual interface
    virtual regfile_if #(BUS_WIDTH, ADDR_WIDTH) regfile_vif;

    // Constructor

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction

    // Build phase

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual regfile_if #(BUS_WIDTH, ADDR_WIDTH))::get(this, "", "regfile_vif", regfile_vif)) begin
            `uvm_fatal("REGFILE_DRV_BLD", "Virtual interface regfile_vif not found")
        end
        `uvm_info(get_name(), "Build phase", UVM_HIGH)
    endfunction

    // Run phase

    task run_phase(uvm_phase phase);
        regfile_seq_item #(ADDR_WIDTH,BUS_WIDTH) seq_item;

        // Get the next sequence item
        seq_item = null;
        seq_item_port.get_next_item(seq_item);

        // Drive the inputs to the DUT

        regfile_vif.rs_store       <= seq_item.rs_store;
        regfile_vif.rs_addr_valid  <= seq_item.rs_addr_valid;
        regfile_vif.imme_data      <= seq_item.imme_data;
        regfile_vif.rd_wr_en       <= seq_item.rd_wr_en;
        regfile_vif.rs1_rs2_rd     <= seq_item.rs1_rs2_rd;
        regfile_vif.alu_data_valid <= seq_item.alu_data_valid;
        regfile_vif.alu_data_out   <= seq_item.alu_data_out;

        // Wait for a clock cycle
        @(posedge regfile_vif.clk);

        // Capture the outputs from the DUT
        seq_item.op_done     = regfile_vif.op_done;
        seq_item.rs_data_mux = regfile_vif.rs_data_mux;
        seq_item.rs_data     = regfile_vif.rs_data;

        // Indicate that the item is done
        seq_item_port.item_done();
        `uvm_info(get_name(), "Run phase", UVM_HIGH)
    endtask : run_phase

endclass: regfile_driver

`endif
