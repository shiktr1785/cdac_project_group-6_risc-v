`ifndef __INSTR_MEM_REFERENCE_MODEL_SV
`define __INSTR_MEM_REFERENCE_MODEL_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class instr_mem_reference_model extends uvm_object;

    `uvm_object_utils(instr_mem_reference_model)

    // Memory Array: 32-bit width, 64 depth
    bit [31:0] rom [64];

    // Internal address tracker
    int current_pc;

    function new(string name = "instr_mem_reference_model");
        super.new(name);
        // Initialize ROM with hardcoded data for testing
        //Siddharth or Shikar ,Change it later
        rom[0] = 32'h00000013; // NOP
        rom[1] = 32'h00100093; // ADDI x1, x0, 1
        rom[2] = 32'h00200113; // ADDI x2, x0, 2
        rom[3] = 32'h002081B3; // ADD x3, x1, x2
        rom[4] = 32'hDEADBEEF; // 

        
        current_pc = 0;
    endfunction

    // Function to get expected instruction and update internal PC
    function bit [31:0] get_expected_instr();
        bit [31:0] expected_data;
        
        // Fetch data if within bounds, else return 0
        expected_data = (current_pc < 64) ? rom[current_pc] : 32'h0;
        
        // Increment the internal tracker
        current_pc++;
        
        return expected_data;
    endfunction

endclass

`endif


