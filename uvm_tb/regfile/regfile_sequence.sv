`ifndef __REGFILE_SEQUENCE_SV
`define __REGFILE_SEQUENCE_SV

//  Class: regfile_sequence #(int BUS_WIDTH=32 , int ADDR_WIDTH=15)
//
class regfile_sequence #(int BUS_WIDTH=32 , int ADDR_WIDTH=15) extends uvm_object;
    `uvm_object_param_utils(regfile_sequence #(BUS_WIDTH,ADDR_WIDTH));
    regfile_seq_item #(ADDR_WIDTH,BUS_WIDTH) seq_item;

    // Constructor

    function new(string name = "regfile_sequence");
        super.new(name);
    endfunction: new

    // Body task

    virtual task body();
        seq_item = regfile_seq_item #(ADDR_WIDTH,BUS_WIDTH)::type_id::create("seq_item");

        // Start the sequence item
        start_item(seq_item);
        finish_item(seq_item);
    endtask : body

    // Constraints
    
endclass: regfile_sequence #(int BUS_WIDTH=32 , int ADDR_WIDTH=15)


`endif
