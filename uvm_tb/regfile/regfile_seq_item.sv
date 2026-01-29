`ifndef __REGFILE_SEQ_ITEM_SV
`define __REGFILE_SEQ_ITEM_SV

class regfile_seq_item #(
    int ADDR_WIDTH = 15,
    int BUS_WIDTH = 32
)extends uvm_sequence_item;
    `uvm_object_param_utils(regfile_seq_item #(ADDR_WIDTH, BUS_WIDTH));

    // Data members

        //INPUTS

         logic rs_store;
         logic rs_addr_valid;

    rand logic [BUS_WIDTH-1:0] imme_data;
    
         logic rd_wr_en;
    rand logic [ADDR_WIDTH-1:0] rs1_rs2_rd;

         logic alu_data_valid;
    rand logic [BUS_WIDTH-1:0] alu_data_out;
    

        //OUTPUTS

    logic op_done;
    logic [BUS_WIDTH-1:0] rs_data_mux;
    logic [BUS_WIDTH-1:0] rs_data;

    // Constructor

    function new(string name = "regfile_seq_item");
        super.new(name);
        `uvm_info(get_name(), "Constructor", UVM_HIGH)
        
    endfunction

    // Display method 

    function void display();
        `uvm_info(get_type_name(), $sformatf("rs_store: %0b, rs_addr_valid: %0b, imme_data: %0h, rd_wr_en: %0b, rs1_rs2_rd: %0h, alu_data_valid: %0b, alu_data_out: %0h, op_done: %0b, rs_data_mux: %0h, rs_data: %0h",
            rs_store, rs_addr_valid, imme_data, rd_wr_en, rs1_rs2_rd, alu_data_valid, alu_data_out, op_done, rs_data_mux, rs_data), UVM_LOW)

        `uvm_info(get_name(), "Display", UVM_HIGH)
        
    endfunction
    
    
endclass: regfile_seq_item

`endif
