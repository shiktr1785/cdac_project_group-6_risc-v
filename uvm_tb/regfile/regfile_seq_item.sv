`ifndef __REGFILE_SEQ_ITEM_SV
`define __REGFILE_SEQ_ITEM_SV

class regfile_seq_item #(
    int ADDR_WIDTH = 15,
    int BUS_WIDTH = 32
)extends uvm_sequence;
    `uvm_object_utils(regfile_seq_item);

    // Data members

        //INPUTS

    rand logic alu_data_valid;
    rand logic [BUS_WIDTH-1:0] rs_data_mux;
    rand logic rs_store;
    rand logic [BUS_WIDTH-1:0] imme_data;
    rand logic rs_addr_valid;
    rand logic rd_wr_en;
    rand logic [ADDR_WIDTH-1:0] rs1_rs2_rd;

        //OUTPUTS

    logic alu_data_valid;
    logic op_done;
    logic [BUS_WIDTH-1:0] rs_data_mux;

    // Constructor

    function new(string name = "regfile_seq_item");
        super.new(name);
    endfunction

    // Print method 

    function void print();
        `uvm_info(get_type_name(), $sformatf("alu_data_valid: %0b, rs_data_mux: %0h, rs_store: %0b, imme_data: %0h, rs_addr_valid: %0b, rd_wr_en: %0b, rs1_rs2_rd: %0h, op_done: %0b",
            alu_data_valid, rs_data_mux, rs_store, imme_data, rs_addr_valid, rd_wr_en, rs1_rs2_rd, op_done), UVM_LOW)
    endfunction
    
    
endclass: regfile_seq_item

`endif
