`ifndef __INSTR_MEM_DRIVER_SV
`define __INSTR_MEM_DRIVER_SV

class instr_mem_driver#(parameter BUS_WIDTH = 32) extends uvm_driver#(instr_mem_seq_item#(BUS_WIDTH));

    `uvm_component_utils(instr_mem_driver#(BUS_WIDTH))

    virtual instr_mem_if#(BUS_WIDTH) vif;

    // Constructor
    function new(string name = "instr_mem_driver", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_name(), "New", UVM_HIGH) // For debugging
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Build Phase", UVM_HIGH) // For debugging
        if(!uvm_config_db#(virtual instr_mem_if#(BUS_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found");
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        instr_mem_seq_item#(BUS_WIDTH) req;
        
        `uvm_info(get_name(), "Run Phase Started", UVM_HIGH) // For debugging
        
        vif.instr_valid <= 1'b0;
        vif.instr <= '0;

        @(posedge vif.clk); // Wait one clock cycle for initialization
    
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("INSTR_MEM_DRIVER", "Got new item from sequencer", UVM_HIGH) // For debugging

            // Wait for next_instr to be asserted
            while (vif.next_instr != 1'b1) begin
                `uvm_info("INSTR_MEM_DRIVER", "Waiting for next_instr", UVM_DEBUG) // For debugging
                @(posedge vif.clk);
            end
            
            // Drive the instruction to the interface
            `uvm_info("INSTR_MEM_DRIVER", $sformatf("Driving instruction: 0x%0h at PC=%0d", req.instr, req.current_pc), UVM_LOW)
            vif.instr <= req.instr;
            vif.instr_valid <= 1'b1;
            
            @(posedge vif.clk); // Hold signal for one cycle
            vif.instr_valid <= 1'b0;
            `uvm_info("INSTR_MEM_DRIVER", "Instruction driven successfully", UVM_HIGH) // For debugging

            seq_item_port.item_done();
        end
    endtask

endclass: instr_mem_driver

`endif


