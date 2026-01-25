`ifndef __INSTR_MEM_DRIVER_SV
`define __INSTR_MEM_DRIVER_SV

class instr_mem_driver #(BUS_WIDTH=32) extends uvm_driver #(instr_mem_seq_item#(BUS_WIDTH));

    `uvm_component_utils(instr_mem_driver#(BUS_WIDTH))

    virtual instr_mem_if #(BUS_WIDTH) vif;

     // Constructor
    function new(string name="instr_mem_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual instr_mem_if#(BUS_WIDTH))::get(this,"","vif", vif))
      `uvm_fatal("NOVIF","Virtual interface not found");
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        instr_mem_seq_item#(BUS_WIDTH) req;
        vif.instr_valid <= 1'b0;
        vif.instruction <= '0;

        // Wait one clock cycle to ensure initialization takes effect
        @(posedge vif.clk);
    
        forever begin
        seq_item_port.get_next_item(req);

        //Condition to check if next_instr is asserted or not
        while (vif.next_instr!=1'b1)
        begin
            @(posedge vif.clk);
        end
        //Drive the instruction to the interface
        `uvm_info("INSTR_MEM_DRIVER", $sformatf("Driving instruction: 0x%0h", req.instruction), UVM_LOW)
        vif.instruction <= req.instruction;
        vif.instr_valid <= 1'b1;
        //Wait for one cycle to hold this signal  
        @(posedge vif.clk);
        vif.instr_valid <= 1'b0;

        seq_item_port.item_done();
        end
  endtask
endclass: instr_mem_driver

`endif

