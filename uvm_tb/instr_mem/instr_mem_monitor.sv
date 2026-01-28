    `ifndef __INSTR_MEM_MONITOR_SV
    `define __INSTR_MEM_MONITOR_SV

    class instr_mem_monitor #(BUS_WIDTH=32) extends uvm_monitor;

        `uvm_component_utils(instr_mem_monitor#(BUS_WIDTH))
        
        // Virtual Interface
        virtual instr_mem_if #(BUS_WIDTH) vif;

        //Port to send data to scoreboard or analysis components
        uvm_analysis_port #(instr_mem_seq_item#(BUS_WIDTH)) instr_ap;


        // Constructor
        function new(string name="instr_mem_monitor", uvm_component parent);
            super.new(name, parent);
            instr_ap = new("instr_ap", this);
            `uvm_info(get_name(), "New", UVM_HIGH)
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
            forever begin
                @(posedge vif.clk iff vif.instr_valid);
                req = instr_mem_seq_item#(BUS_WIDTH)::type_id::create("req"); 
                req.instruction = vif.instruction;
                req.instr_valid = vif.instr_valid;
                `uvm_info("INSTR_MEM_MONITOR", $sformatf("Monitoring instruction: 0x%0h", req.instruction), UVM_LOW)
                
                //send data to scoreboard
                instr_ap.write(req);
                check_assertions();
            end
            `uvm_info(get_name(), "Run Phase", UVM_HIGH)
        endtask

        //Task to check for Assertions
        task check_assertions();
            //To store the value of the previous next_instr for checking assertions
            logic prev_next_instr=0;
            forever begin
                @(posedge vif.clk);

                //Assertion-1
                //instr_valid shoudl stay high for only one cycle
                if(vif.instr_valid) begin
                    fork 
                        begin
                            @(posedge vif.clk);
                            assert (!vif.instr_valid)
                                else `uvm_error("ASSERT","Instr_valid stayed high for more than one cycle")                    
                        end
                    join_none
                end 

                //Assertion-2
                //To get instr_valid only after next_instr
                if(vif.instr_valid) begin
                            assert (!vif.instr_valid)
                                else `uvm_error("ASSERT","Instr_valid asserted without next_instr ")    
                end

                //Save state for next cycle
                prev_next_instr = vif.next_instr;
            end
        endtask
                
    endclass

    `endif

