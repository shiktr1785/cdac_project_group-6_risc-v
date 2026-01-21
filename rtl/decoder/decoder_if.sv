`ifndef __DECODER_IF_SV
`define __DECODER_IF_SV

interface decoder_if #(
    integer BUS_WIDTH = 32,
    integer OPCODE_WIDTH = 11,
    integer ADDR_WIDTH = 5)
   
    (input bit clk);

    //Interface signals

    // Inputs to the Decoder Unit
    logic                       instr_valid;  //instr_valid indicates if the current instruction is valid
    logic   [BUS_WIDTH-1:0]     instr; 
    logic   [OPCODE_WIDTH-1:0]  op_done;
    logic                       next_instr;   //next_instr indicates if the next instruction is ready to be decoded
    
    // Outputs from the Decoder Unit
    logic   [BUS_WIDTH-1:0]     imme_value;     //Decoded Immediate value
    logic   [OPCODE_WIDTH-1:0]  opcode;         //Decoded Opcode
    logic   [ADDR_WIDTH-1:0]    rd_addr;        //RD address
    logic   [ADDR_WIDTH-1:0]    rs_addr;        //RS address
    logic                       rs_addr_sel;    //RS MUX
    logic                       rs_addr_valid;  //RS valid

    //the current instruction to be decoded
    clocking drv_cb @(posedge clk);

        default input #1step output #1;      
        output instr_valid;
        output instr;
        output op_done;
        output next_instr;
        input imme_value;       
        input opcode;           
        input rd_addr;          
        input rs_addr;          
        input rs_addr_sel;      
        input rs_addr_valid;    

    endclocking

    clocking mon_cb @(posedge clk);
        
        default input #1step output #1;
        input instr;
        input instr_valid;
        input op_done;
        input next_instr;
        input imme_value;            
        input opcode;
        input rd_addr;
        input rs_addr;
        input rs_addr_sel;
        input rs_addr_valid;

    endclocking

    //driver direction
    modport driver (
        output instr_valid,
        output instr,
        output op_done,
        output next_instr,
        input imme_value,      
        input opcode,       
        input rd_addr,          
        input rs_addr,          
        input rs_addr_sel,      
        input rs_addr_valid   
        ); 

    //monitor direction
    modport monitor(
        input instr,
        input instr_valid,
        input op_done,
        input next_instr,
        input imme_value,            
        input opcode,
        input rd_addr,
        input rs_addr,
        input rs_addr_sel,
        input rs_addr_valid
    );
    
endinterface : decoder_if

`endif

 
