// rete sequenzaile sincronizzata
/*
    N ingressi x, M uscite z, W stati interni y
    funzionamento:
    RCA prende in ingresso gli x e gli y, produce W a
    STAR prende in ingresso gli a prodotti da RCA e restituisce gli y che tornano in RCA
    RCB prende in ingresso gli y prodotti da STAR e gli ingressi x, fa uscire gli z
    il fatto che RCB abbia in ingresso anche gli x è la differenza con Moore
    infatti RCA ed RCB in questo modello vengono 'fuse' in RC
    RC prende in ingresso gli x e gli y, da in uscita gli z e gli a nel registro STAR
    STAR prende gli a e rimette gli y in RC
*/
// il clock deve andare più lentamente rispetto ad una rete di Moore

module Rete_di_Mealy (
    x, clock, reset_,
    z
);
    input clock, reset_;
    input [N-1:0] x;
    output [M-1:0] z;

    reg [W-1:0] STAR; parameter S0 = codifica0, ....;
    assign z = (STAR==S0)? ZS0(x):
                ...
    always @(reset_==0) #1 STAR <= stato_interno_iniziale;
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0: STAR <= aS0(x);
            ...
endmodule

// rispetto a Moore qui l'uscita dipende dallo stato di ingresso presente al clock attuale
// quindi non si perde un clock
// però sono reti trasparenti
