module bad_alu;
    logic a;
    logic c;
    logic f;

    assign b = a;   // Error: 'b' is not declared
    assign c = d;   // Error: 'd' is not declared
    assign g = f;   // Error: 'g' is not declared
endmodule
