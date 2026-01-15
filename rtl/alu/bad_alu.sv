module bad_alu;
    logic a;
    logic c;
    logic f;
    logic l;

    assign b = a;   // Error: 'b' is not declared
    assign c = d;   // Error: 'd' is not declared
    assign g = f;   // Error: 'g' is not declared
    assign m = l;   // Error: 'm' is not declared
endmodule
