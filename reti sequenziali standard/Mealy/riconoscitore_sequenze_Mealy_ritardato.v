// riconoscitore di sequenze (modello di Mealy ritardato)
/*
    N ingressi x, 1 uscita z
    sequenza a K stati di ingresso implica K stati interni (perchè non si perde clock)
    z=1 quando sequenza rispettata, z=0 altrimenti
*/

// riconoscitore di sequenze 11, 01, 10
/*
    2 ingressi x, 1 uscita z, 3 stati di ingresso
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
    reg STAR[1:0]; parameter S0 = 'B00, S1 = 'B01, S2 = 'B10;
    reg OUTR; assign z = OUTR;

    always @(reset_==0) #1 begin OUTR <= 0; STAR <= S0; end
    always @(posedge clock) if(reset_==1) #3
    // legge A
        casex(STAR)
            S0: begin OUTR <= 0; STAR <= (x=='B11)? S1:S0; end
            S1: begin OUTR <= 0; 
                STAR <= (x=='B01)? S2: (x=='B11)? S1:S0; end
            S2: begin OUTR <= (x=='B10)? 1:0; STAR <= (x=='B11)? S1:S0;end
        endcase    
endmodule
