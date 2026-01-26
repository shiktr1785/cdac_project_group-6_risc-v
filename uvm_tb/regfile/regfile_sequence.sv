`ifndef __REGFILE_SEQUENCE_SV
`define __REGFILE_SEQUENCE_SV

//  Class: regfile_sequence 
//
class regfile_sequence #(int BUS_WIDTH=32 , int ADDR_WIDTH=15) extends uvm_sequence;

    `uvm_object_param_utils(regfile_sequence #(BUS_WIDTH,ADDR_WIDTH));
    regfile_seq_item #(ADDR_WIDTH,BUS_WIDTH) seq_item;

    // Constructor

    function new(string name = "regfile_sequence");
        super.new(name);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
    endfunction: new

    // Body task

    virtual task body();
        seq_item = regfile_seq_item #(ADDR_WIDTH,BUS_WIDTH)::type_id::create("seq_item");

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
        `uvm_info(get_name(), "Body", UVM_HIGH)
        
    endtask : body

    // Constraints

    constraint imme_data_boundary_c{
        seq_itemimme_data inside { 32'h00000000, 32'h00000001, 32'hFFFFFFFF, 32'h7FFFFFFF, 32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }

    constraint rs1_rs2_rd_c {
    // rd: Bits [14:10] - Target 0 (hardwired), 1, 30, 31 (boundaries)
    seq_item.rs1_rs2_rd[ADDR_WIDTH-1:ADDR_WIDTH-5] inside {
        5'd0, 5'd1, 5'd15, 5'd16, 5'd30, 5'd31
    };

    // rs2: Bits [9:5] - Target 0, 1, 30, 31
    seq_item.rs1_rs2_rd[ADDR_WIDTH-6:ADDR_WIDTH-10] inside {
        5'd0, 5'd1, 5'd15, 5'd16, 5'd30, 5'd31
    };

    // rs1: Bits [4:0] - Target 0, 1, 30, 31
    seq_item.rs1_rs2_rd[ADDR_WIDTH-11:ADDR_WIDTH-15] inside {
        5'd0, 5'd1, 5'd15, 5'd16, 5'd30, 5'd31
    };
}

    constraint alu_data_out_boundary_c{
        seq_item.alu_data_out inside { 32'h00000000, 32'h00000001, 32'hFFFFFFFF, 32'h7FFFFFFF, 32'h80000000, 32'hAAAAAAAA, 32'h55555555};
    }
    
endclass: regfile_sequence 

`endif
