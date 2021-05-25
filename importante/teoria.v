// DESCRIZIONE  RSS
// ~

module descrizione (
    x, y, reset_, clock,
    z
);
    // definizioni delle porte
    input[1:0] x;
    inout y;
    output[2:0] z;
    input clock, reset_;

    // gestione inout
    assign y = (x==B'00)? 0 : 'BZ;  // se x==00 y da in out 0 altrimenti alta impedenza
                                    // e quindi si usa per l'input
    // definizione fili
    wire filo;
    Rete_Combinatoria RC(.x(in), .filo(out));

    // registri operativi
    reg[2:0] Z; assign z = Z;
    reg[2:0] COUNT;

    // registro di stato
    reg[1:0] STAR; parameter S0=0, S1=1, S2=2;

    always @(reset_==0) #1
        begin
            COUNT <= 0;
            Z <= 0;
            STAR <= S0;
        end
    
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    COUNT <= COUNT + 1;
                    STAR <= S1;
                end
            S1:
                begin
                    Z <= {x, filo[0], filo[1]};
                    STAR <= (COUNT==5)? S2 : S0;
                end
            S2:
                begin
                    COUNT <= 0;
                    STAR <= S0;
                end
        endcase
endmodule

module Rete_Combinatoria (
    in, out
);
    input[1:0] in;
    output out;

    assign out = in[0] & ~in[1];

endmodule

// SINTESI RSS

module sintesi (
    x, y, reset_, clock,
    z
);
    // definizioni delle porte
    input[1:0] x;
    inout y;
    output[2:0] z;
    input clock, reset_;

    wire c0;
    wire b0, b1, b2;

    Parte_Operativa PO(x, y, reset_, clock, z, b0, b1, b2, c0);
    Parte_Controllo PC(reset_, clock, b0, b1, b2, c0);

endmodule

module Parte_Operativa (
    x, y, reset_, clock, z, b0, b1, b2, c0
);
    // definizioni delle porte
    input[1:0] x;
    inout y;
    output[2:0] z;
    input clock, reset_;

    input b0, b1, b2;
    output c0;

    // gestione inout
    assign y = (x==B'00)? 0 : 'BZ;  // se x==00 y da in out 0 altrimenti alta impedenza
                                    // e quindi si usa per l'input
    // definizione fili
    wire filo;
    Rete_Combinatoria RC(.x(in), .filo(out));

    // registri operativi
    reg[2:0] Z; assign z = Z;
    reg[2:0] COUNT;

    // gestione var. condizionamento  (5=0101)
    assign c0 = (~COUNT[3] & ~COUNT[1] & COUNT[2] & COUNT[0]);  // c0 = 1 se COUNT = 5

    // multiplexer di Z
    always @(reset_==0) #1 Z <= 0;
    always @(posedge clock) 
        casex(b0)
            'B0: Z <= {x, filo[0], filo[1]};    //S2
            'B1: Z <= Z;                        //other
        endcase
            
    // multiplexer di COUNT
    always @(reset_==0) #1 COUNT <= 0;
    always @(posedge clock) 
        casex({b2, b1})
            'B00: COUNT <= COUNT + 1;   // S0
            'B01: COUNT <= 0;           // S2
            'B10: COUNT <= COUNT;       // S1
        endcase
endmodule

module Parte_Controllo (
    reset_, clock, b0, b1, b2, c0
);
    input c0;
    input clock, reset_;

    output b0, b1, b2;

    // registro di stato
    reg[1:0] STAR; parameter S0=0, S1=1, S2=2;

    //variabili comando
    assign {b2, b1, b0} =   (STAR == S0)?001:
                            (STAR == S1)?101:
                            (STAR == S2)?010:
                            /*default*/ 'BXXX;


    always @(reset_==0) #1 STAR <= S0;

    always @(posedge clock)
        casex(STAR)
            S0: STAR <= S1;
            S1: STAR <= (c0==1)? S2 : S0;
            S2: STAR <= S0;
        endcase
endmodule

/*              RAM commentatas

actual_microaddress     b2b1b0       eff       next_microaddressT            next_microaddressF
    00                    001         0               01                             01
    01                    101         0               10                             00
    10                    010         0               00                             00

*/