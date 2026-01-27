`ifndef __REGFILE_REFERENCE_MODEL_SV
`define __REGFILE_REFERENCE_MODEL_SV

class regfile_reference_model #(parameter BUS_WIDTH = 32, parameter ADDR_WIDTH = 15) extends uvm_object;

    `uvm_object_utils(regfile_reference_model #(BUS_WIDTH, ADDR_WIDTH))

    // Register file storage: 32 registers (RISC-V standard)
    bit [BUS_WIDTH-1:0] registers[32];

    function new(string name = "regfile_reference_model");
        super.new(name);
        // Initialize all registers to 0
        for (int i = 0; i < 32; i++) begin
            registers[i] = '0;
        end
    endfunction

    // Function to update register on write and return read data
    function bit [BUS_WIDTH-1:0] predict(logic [ADDR_WIDTH-1:0] addr, bit rd_wr_en, bit [BUS_WIDTH-1:0] write_data);
        bit [BUS_WIDTH-1:0] read_data;
        logic [4:0] reg_addr;

        // Extract lower 5 bits for register address (for 32 registers)
        reg_addr = addr[4:0];

        if (rd_wr_en) begin
            // Write operation: Update the register
            registers[reg_addr] = write_data;
            `uvm_info("REF_MODEL", $sformatf("Write: x%0d <= 0x%0h", reg_addr, write_data), UVM_HIGH)
            return write_data;
        end else begin
            // Read operation: Return the current register value
            read_data = registers[reg_addr];
            `uvm_info("REF_MODEL", $sformatf("Read: x%0d => 0x%0h", reg_addr, read_data), UVM_HIGH)
            return read_data;
        end
    endfunction

    // Function to set a register value directly (useful for initialization)
    function void set_register(logic [4:0] reg_id, bit [BUS_WIDTH-1:0] value);
        registers[reg_id] = value;
        `uvm_info("REF_MODEL", $sformatf("Set: x%0d = 0x%0h", reg_id, value), UVM_HIGH)
    endfunction

    // Function to get a register value
    function bit [BUS_WIDTH-1:0] get_register(logic [4:0] reg_id);
        return registers[reg_id];
    endfunction

    // Function to reset all registers
    function void reset();
        for (int i = 0; i < 32; i++) begin
            registers[i] = '0;
        end
        `uvm_info("REF_MODEL", "All registers reset to 0", UVM_MEDIUM)
    endfunction

endclass : regfile_reference_model

`endif
