module instr_mem_tb_top;

    // Parameters
    parameter BUS_WIDTH = 32;
    
    // Clock generation
    bit clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // interface instance
    instr_mem_if#(BUS_WIDTH) vif(clk);
    
    // Dut instance 
    instr_mem_v1 dut (
        .instr(vif.instr),
        .next_instr(vif.next_instr),
        .clk(vif.clk),
        .reset_n(vif.reset_n)
    );
    
    always_ff @(posedge clk or negedge vif.reset_n) begin
        if (!vif.reset_n)
            vif.instr_valid <= 1'b0;
        else
            vif.instr_valid <= vif.next_instr;
    end
    
    //  Test body
    initial begin
        import uvm_pkg::*;
        import instr_mem_pkg::*;
        uvm_config_db#(virtual instr_mem_if#(BUS_WIDTH))::set(null, "*", "vif", vif);
        vif.reset_n = 0;
        vif.next_instr = 0;
        repeat(5)
        @(posedge clk);
        vif.reset_n = 1;
        @(posedge clk);
        // Run the test
        run_test("instr_mem_simple_test");
    end

endmodule
