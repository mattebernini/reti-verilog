// rete sequenzaile sincronizzata
/*
    N ingressi x, M uscite z, W stati interni
    funzionamento:
    x entra in ingresso nella RCA insieme a W stati interni y
    RCA da in uscita W a che vanno in ingresso al registro STAR
    STAR memorizza gli stati di ingresso a e li manda in input di nuovo a RCA ed a RCB
    RCB prende in ingresso W y da STAR e manda in output M z

    x -> RCA STAR RCB -> z
*/

module Rete_di_Moore (
    x, clock, reset_,
    z
);
    input clock, reset_;
    input [N-1:0] x;
    output [M-1:0] z;
    // parameter = dichiarazione di costante
    reg [W-1:0] STAR; parameter S0=codifica0,...,SK-1 =codificaK-1;
    // legge B  --> in base allo stato interno crea l'output
    assign z = (STAR == SO)? ZS0 :
                             ...
                             ZSK-1;
    always @(reset_ == 0) #1 STAR<=stato_interno_iniziale;
    // legge A  --> crea il nuovo stato interno
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0 : STAR<=aS0(x);
            ...
            SK-1 : STAR<=aSK-1(x);
        endcase
endmodule

// l'uscita è un clock in ritardo rispetto all'ingresso che l'ha generata
