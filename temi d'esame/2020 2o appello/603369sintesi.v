// sintesi di soluzione.v

module ABC (
    reset_, clock,
    colore, endline, dav_,
    b1, b2, b3, b4, b5, b6, b7. b8, b9,
    c
    rfd, txd
);
    input reset_, clock;
    input colore, endline, dav_;
    output rfd, txd;

    wire c;
    wire b1, b2, b3, b4, b5, b6, b7. b8, b9;

    Parte_Operativa PO();
    Parte_Controllo PC();

endmodule

module Parte_Operativa (
    reset_, clock,
    colore, endline, dav_,
    rfd, txd
);
    input reset_, clock;
    input colore, endline, dav_;
    output rfd, txd;

    // quante b e quanti c mi servono? 
    input b0, 
    output

    // reg operativi
    reg [6:0] N;
    reg [4:0] COUNT;
    reg [9:0] BUFFER;
    reg       RFD, COLORE, TXD;
    assign txd=TXD, rfd=RFD;

    localparam marking = 1'B1, start_b = 1'B0, stop_b = 1'B1;
    localparam bianco = 1'B0, nero = 1'B1;

    // multiplexer di N
    always @(reset_==0) #1 N <= 0;
    always @(posedge clock) 
        casex({b0, b1})
            'B00: N <= (COLORE==colore) ? N+1 : N;       // S1
            'B01: N <= (endline == 0) ? 1 : 0;           // S2
            'B10: N <= N;                                // other
        endcase

    // multiplexer di COUNT
    always @(reset_==0) #1 COUNT <= 0;
    always @(posedge clock) 
        casex({b3, b2})
            'B00: COUNT <= COUNT - 1;   // S3
            'B01: COUNT <= 9;           // S2
            'B10: COUNT <= COUNT;       // other
        endcase
    
    // multiplexer di BUFFER
    always @(reset_==0) #1 BUFFER <= 0;
    always @(posedge clock) 
        casex({b5, b4})
            'B00: BUFFER <= (endline == 0) ? 
                        {stop_b, N, COLORE, start_b} :
                        {stop_b, 8'H00, start_b};       // S2
            'B01: BUFFER <= {marking, BUFFER[9:1]};    // S3
            'B10: BUFFER <= BUFFER;       // other
        endcase

    // multiplexer di RFD
    always @(reset_==0) #1 RFD <= 1;
    always @(posedge clock) 
        casex({b7, b6})
            'B00: RFD <= 1;         // S0
            'B01: RFD <= 0;         // S4
            'B10: RFD <= RFD;       // other
        endcase

    // multiplexer di COLORE
    always @(reset_==0) #1 COLORE <= 1;
    always @(posedge clock) 
        casex(b8)
            'B0: COLORE <= colore;         // S2
            'B1: COLORE <= COLORE;       // other
        endcase

    // multiplexer di TXD
    always @(reset_==0) #1 TXD <= marking;
    always @(posedge clock) 
        casex(b9)
            'B0: TXD <= BUFFER[0];         // S3
            'B1: TXD <= TXD;               // other
        endcase
endmodule