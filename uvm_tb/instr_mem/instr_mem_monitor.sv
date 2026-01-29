`ifndef __INSTR_MEM_MONITOR_SV
`define __INSTR_MEM_MONITOR_SV

class instr_mem_monitor#(parameter BUS_WIDTH = 32) extends uvm_monitor;

    `uvm_component_utils(instr_mem_monitor#(BUS_WIDTH))
    
    // Virtual Interface
    virtual instr_mem_if#(BUS_WIDTH) vif;

    // Port to send data to scoreboard or analysis components
    uvm_analysis_port#(instr_mem_seq_item#(BUS_WIDTH)) instr_ap;

    // Constructor
    function new(string name = "instr_mem_monitor", uvm_component parent);
        super.new(name, parent);
        instr_ap = new("instr_ap", this);
        `uvm_info(get_name(), "New", UVM_HIGH)
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Build Phase", UVM_HIGH)
        if(!uvm_config_db#(virtual instr_mem_if#(BUS_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found");
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        instr_mem_seq_item#(BUS_WIDTH) req;
        
        `uvm_info(get_name(), "Run Phase Started", UVM_HIGH)
        
        fork
            check_assertions();
        join_none
        
        forever begin
            @(posedge vif.clk);
            
            if (vif.reset_n && vif.instr_valid) begin
                req = instr_mem_seq_item#(BUS_WIDTH)::type_id::create("req");
                // Sample all signals
                req.reset_n = vif.reset_n;
                req.next_instr = vif.next_instr;
                req.instr = vif.instr;
                req.instr_valid = vif.instr_valid;
                `uvm_info("INSTR_MEM_MONITOR", $sformatf("Monitoring instruction: 0x%0h, instr_valid=%0b", 
                          req.instr, req.instr_valid), UVM_MEDIUM)
                
                // Send data to scoreboard
                instr_ap.write(req);
            end
        end
    endtask

    // Assertions
    task check_assertions();
        logic prev_next_instr = 0;
        logic prev_reset_n = 0;
        
        forever begin
            @(posedge vif.clk);
            
            // Instr_valid should stay high for only one cycle
            if (vif.instr_valid && vif.reset_n) begin
                fork
                    begin
                        @(posedge vif.clk);
                        if (vif.reset_n) begin
                            assert (!vif.instr_valid)
                            else `uvm_error("MONITOR", "instr_valid stayed high for more than one cycle")
                        end
                    end
                join_none
            end

            // Instr_valid should only come after next_instr
            if (vif.instr_valid && vif.reset_n) begin
                assert (prev_next_instr)
                else `uvm_error("MONITOR", "instr_valid asserted without next_instr in previous cycle")
            end

            // Reset should clear instr_valid
            if (!vif.reset_n) begin
                assert (!vif.instr_valid)
                else `uvm_error("MONITOR", "instr_valid not cleared during reset")
            end

            // instr_valid should be low when next_instr was low
            if (!prev_next_instr && prev_reset_n && vif.reset_n) begin
                assert (!vif.instr_valid)
                else `uvm_error("MONITOR", "instr_valid high when next_instr was low in previous cycle")
            end

            //Save the values fro comparing next cycle
            prev_next_instr = vif.next_instr;
            prev_reset_n = vif.reset_n;
        end
    endtask
            
endclass: instr_mem_monitor

`endif

