<<<<<<< Updated upstream
`ifndef INSTR_MEM_PKG_SV
`define INSTR_MEM_PKG_SV

package instr_mem_pkg;

    import uvm_pkg::*;
 
    `include "uvm_macros.svh"
    `include "instr_mem_seq_item.sv"
    `include "instr_mem_sequence.sv"
    
endpackage

`endif
=======
`ifndef __INSTR_MEM_PKG_SV
`define __INSTR_MEM_PKG_SV

`include "uvm_macros.svh"
import uvm_pkg::*; 
 
package instr_mem_pkg;

    // Importing the sequence item and sequence classes
    
    `include "instr_mem_seq_item.sv"   
    `include "instr_mem_sequence.sv" 
 endpackage

`endif 
>>>>>>> Stashed changes
