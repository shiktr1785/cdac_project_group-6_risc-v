`ifndef __REGFILE_SEQ_ITEM_SV
`define __REGFILE_SEQ_ITEM_SV

class regfile_seq_item #(
    int ADDR_WIDTH = 15,
    int BUS_WIDTH = 32
)extends uvm_sequence;
    `uvm_object_utils(regfile_seq_item);

    // Data members

        //INPUTS

    rand logic rs_store;
    rand logic rs_addr_valid;

    rand logic [BUS_WIDTH-1:0] imme_data;
    
    rand logic rd_wr_en;
    rand logic [ADDR_WIDTH-1:0] rs1_rs2_rd;

    rand logic alu_data_valid;
    rand logic [BUS_WIDTH-1:0] alu_data_out;
    

        //OUTPUTS

    logic op_done;
    logic [BUS_WIDTH-1:0] rs_data_mux;
    logic [BUS_WIDTH-1:0] rs_data;

    // Constructor

    function new(string name = "regfile_seq_item");
        super.new(name);
    endfunction

    // Print method 

    function void print();
        `uvm_info(get_type_name(), $sformatf("rs_store: %0b, rs_addr_valid: %0b, imme_data: %0h, rd_wr_en: %0b, rs1_rs2_rd: %0h, alu_data_valid: %0b, alu_data_out: %0h, op_done: %0b, rs_data_mux: %0h, rs_data: %0h",
            rs_store, rs_addr_valid, imme_data, rd_wr_en, rs1_rs2_rd, alu_data_valid, alu_data_out, op_done, rs_data_mux, rs_data), UVM_LOW)
    endfunction
    
    
endclass: regfile_seq_item

`endif
