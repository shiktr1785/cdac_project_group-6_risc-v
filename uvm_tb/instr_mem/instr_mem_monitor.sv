`ifndef __INSTR_MEM_MONITOR_SV
`define __INSTR_MEM_MONITOR_SV

class instr_mem_monitor#(parameter BUS_WIDTH = 32) extends uvm_monitor;

    `uvm_component_utils(instr_mem_monitor#(BUS_WIDTH))
    
    virtual instr_mem_if#(BUS_WIDTH) vif;
    uvm_analysis_port#(instr_mem_seq_item#(BUS_WIDTH)) instr_ap;

    function new(string name = "instr_mem_monitor", uvm_component parent);
        super.new(name, parent);
        instr_ap = new("instr_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual instr_mem_if#(BUS_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found");
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        instr_mem_seq_item#(BUS_WIDTH) req;
        
        // Wait for Reset Release
        wait(vif.reset_n === 1);
        `uvm_info(get_name(), "Run Phase Started", UVM_HIGH)

        //Parallel checking of assertions and monitor code
        fork
            check_assertions();
        join_none

        // Main Monitoring Section
        forever begin
            @(posedge vif.clk);
            
            if (vif.reset_n && vif.instr_valid) begin
                req = instr_mem_seq_item#(BUS_WIDTH)::type_id::create("req");
                req.instr = vif.instr;
                req.instr_valid = vif.instr_valid;
                // Optional
                req.next_instr = vif.next_instr; 
                `uvm_info("MON", $sformatf("Sampled: 0x%0h", req.instr), UVM_HIGH)
                instr_ap.write(req);
            end
        end
    endtask