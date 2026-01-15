module bad_alu;
    logic a;
    logic c;

    assign b = a;   // Error: 'b' is not declared
    assign c = d;   // Error: 'd' is not declared
endmodule
