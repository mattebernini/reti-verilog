// rete sequenzaile sincronizzata (modello di Moore)
/*
    due ingressi: j e k
    all'arrivo del clock:
    00 conserva
    10 setta
    01 resetta
    11 commuta
*/

module FlipFlop_JK (
    j, k, clock, reset_,
    q
);
    input j, k, clock, reset_;
    output q;
    reg STAR; parameter SO='B0, S1='B1;
    assign q = (STAR==S0) ? 0 : 1;      //legge B (un cortocircuito)

    always @(reset_==0) #1 STAR<=S0;
    always @(posedge clock) if(reset_==1) #3
    //legge A
        casex(STAR)
            S0: STAR <= (j==0)? S0:S1;
            S1: STAR <= (k==0)? S1:S0;
        endcase    
endmodule