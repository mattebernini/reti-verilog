// riconoscitore di sequenze (modello di Moore)
/*
    N ingressi x, 1 uscita z
    sequenza a K stati di ingresso implica K+1 stati interni
    z=1 quando sequenza rispettata, z=0 altrimenti
*/


// riconoscitore di sequenze 11, 01, 10
/*
    2 ingressi x, 1 uscita z, 4 stati di ingresso
    z = 1 solo quando gli ingressi sono dati con questa sequenza:
    11, 01, 10 (3 stati d'ingresso)
    altrimenti z = 0
*/
module riconoscitore_sequenza (
    x, clock, reset_,
    z
);
    input [1:0] x;
    input clock, reset_;
    output z;
    // nel parameter c'è la codifica degli stati interni
    reg STAR[1:0]; parameter S0 = B'00, S1 = B'01, S2 = B'10, S3 = B'11;
    // legge B
    assign z = (STAR==S3)? 1:0;

    always @(reset_==0) #1 STAR <= S0;
    always @(posedge clock) if(reset_==1) #3
    // legge A
        casex(STAR)
            S0: STAR <= (x==B'11)? S1:S0;
            S1: STAR <= (x==B'01)? S2: (x==B'11)? S1:S0;
            S2: STAR <= (x==B'10)? S3: (x==B'11)? S1:S0;
            S3: STAR <= (x==B'11)? S1:S0;
        endcase    
endmodule