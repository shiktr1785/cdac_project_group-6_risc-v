`ifndef DECODER_SEQUENCE_SV
`define DECODER_SEQUENCE_SV

class decoder_sequence extends uvm_sequence #(decoder_sequence_item #(15, 32, 4));

    // Factory Registration
    `uvm_object_utils(decoder_sequence)

    rand integer num_transactions;
    
    // Control Generation Mode
    typedef enum bit [1:0] {
        legal   = 2'b00,  // Only valid RISC-V opcodes (R, I, S)
        illegal = 2'b01,  // Only undefined opcodes
        mixed   = 2'b10   // Random mix (80% Legal, 20% Illegal)
    } seq_mode;

    rand seq_mode mode;

    // Limit number of transactions by default
    constraint limit_trans_c {
        num_transactions inside {[20:100]};
    }

    constraint default_mode {
        soft mode == mixed;
    }

    
    // Constructor
    function new(string name = "decoder_sequence");
        super.new(name);
    endfunction

   
    // Body Task
    virtual task body();
        `uvm_info(get_type_name(), $sformatf("Starting Sequence | Mode: %s | Count: %0d", mode.name(), num_transactions), UVM_LOW)

        repeat (num_transactions) begin
            // Create the item using the factory
            req = decoder_sequence_item#(15, 32, 4)::type_id::create("req");
            
            start_item(req);

          	// 1. Disable ALL operational constraints first to start with a clean slate.
            req.c_legal.constraint_mode(0);
            req.c_illegal.constraint_mode(0);
            req.c_mixed.constraint_mode(0);

            // 2. Enable ONLY the one matching the selected mode
            case (mode)
                legal:   req.c_legal.constraint_mode(1);
                illegal: req.c_illegal.constraint_mode(1);
                mixed:   req.c_mixed.constraint_mode(1);
            endcase

            // 3. Randomize 
            if (!req.randomize()) begin
                `uvm_fatal("SEQ_ERR", "Randomization failed for decoder item")
            end

            finish_item(req);
            get_response(rsp);
        end

        `uvm_info(get_type_name(), "Sequence Completed", UVM_LOW)
    endtask

endclass

`endif // DECODER_SEQUENCE_SV
