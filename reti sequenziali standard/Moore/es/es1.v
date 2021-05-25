/*
    Descrivere e sintetizzare col modello di Moore:
    riconoscitore di sequenza 0 0 1 0 1 1 0
*/
module descrizione (
    clock, reset_,
    x, z
);
    input clock, reset_;
    input x;
    output z;

    reg [2:0] STAR;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;

    // legge B
    assign z = (STAR == S7)? 1 : 0;
    always @(reset_ == 0) #1 STAR<=S0;
    // legge A  
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0: (x==0)? STAR<=S1 : STAR<=S0;
            S1: (x==0)? STAR<=S2 : STAR<=S0;
            S2: (x==1)? STAR<=S3 : STAR<=S1;
            S3: (x==0)? STAR<=S4 : STAR<=S0;
            S4: (x==1)? STAR<=S5 : STAR<=S1;
            S5: (x==1)? STAR<=S6 : STAR<=S1;
            S6: (x==0)? STAR<=S7 : STAR<=S0;
            S7: (x==1)? STAR<=S0 : STAR<=S1;
        endcase
endmodule

module RCA (
    x, y, a
);
    input x;
    input [2:0] y;
    output [2:0] a;
    
endmodule

module RCB (
    a, z
);
    input [2:0] a;
    output z;

    assign z = a[2] & s[1] & a[0];
endmodule