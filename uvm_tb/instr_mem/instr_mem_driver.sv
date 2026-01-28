`ifndef __INSTR_MEM_DRIVER_SV
`define __INSTR_MEM_DRIVER_SV

class instr_mem_driver#(parameter BUS_WIDTH = 32) extends uvm_driver#(instr_mem_seq_item#(BUS_WIDTH));

    `uvm_component_utils(instr_mem_driver#(BUS_WIDTH))

    virtual instr_mem_if#(BUS_WIDTH) vif;

    function new(string name = "instr_mem_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual instr_mem_if#(BUS_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found");
    endfunction

    task run_phase(uvm_phase phase);
        instr_mem_seq_item#(BUS_WIDTH) req;
        
        // Initialize Inputs
        vif.next_instr <= 1'b0;
        
        // Wait for Reset
        wait(vif.reset_n === 1);
        @(posedge vif.clk); 
    
        forever begin
            seq_item_port.get_next_item(req);
            
            // DRIVE THE INPUT: Send the request to the DUT
            vif.next_instr <= req.next_instr;
            
            @(posedge vif.clk);

            seq_item_port.item_done();
        end
    endtask

endclass: instr_mem_driver

`endif