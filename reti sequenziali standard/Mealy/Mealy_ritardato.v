// rende una rete di Mealy non trasparente 
// aggiungendo un registro OUTR dopo RCB
/* 
    lo stato di uscita cambia dopo il clock,
    ed il suo valore dipende dallo stato di 
    ingresso e dallo stato interno marcato
    precedenti all'arrivo del clock.
*/

module Rete_di_Mealy_Ritardato (
    x, clock, reset_,
    z
);
    input clock, reset_;
    input [N-1:0] x;
    output [M-1:0] z;

    reg [W-1:0] STAR; parameter S0 = codifica0, ....;
    reg [M-1:0] OUTR; assign z = OUTR;
                ...
    always @(reset_==0) #1 begin OUTR <= ...; STAR <= ...; end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0: begin OUTR <= zS0(x); STAR <= aS0(x); end
            ...
endmodule

// gli <= tra begin ed end sono fatti in simultanea