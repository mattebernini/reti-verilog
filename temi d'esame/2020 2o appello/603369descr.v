module ABC (
    reset_, clock,
    colore, endline, dav_,
    rfd, txd
);
    input reset_, clock;
    input colore, endline, dav_;
    output rfd, txd;

    reg RFD, TXD;
    assign rfd = RFD;
    assign txd = TXD;

    reg [3:0] COUNT;        // per trasmissione seriale
    reg [9:0] BUFFER;
    reg COLORE;

    reg[2:0] STAR; parameter S0=0, S1=1, S2=2, S3=3, S4=4;
    parameter nero = 1'B1, bianco = 1'B1, marking = 1'B1, spacing = 1'B0;
    
    always @(reset_==0) #1
        begin
            COLORE <= nero;
            BUFFER <= 0;
            STAR <= S0;
            RFD <= 1;
            TXD <= marking;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    RFD <= 1;
                    BUFFER <= (colore==COLORE & dav_==0)? BUFFER + 1 : BUFFER;
                    STAR <= (dav_==0 & endline==0)? ((colore==COLORE)? S1 : S2) : ((endline==1)? S3 : S0);
                end
            S1:             // altro pixel dello stesso colore
                begin
                    RFD <= 0;
                    BUFFER <= (BUFFER==0)? BUFFER+1 : BUFFER;   // se finisce di essere trasmesso devo metterlo a 1
                    STAR <= (dav_==1)? S0 : S1;
                end
            S2:             // cambio colore
                begin
                    BUFFER <= {marking, BUFFER[6:0], COLORE, spacing};
                    COUNT <= 10;
                    COLORE <= colore;
                    RFD <= 0;
                    STAR <= S4;
                end
            S3:             // endline
                begin
                    BUFFER <= {marking, 8'H00, spacing};
                    RFD <= 0;
                    COUNT <= 10;
                    STAR <= S4;
                end
            S4:         // trasmissione seriale
                begin
                    COUNT <= COUNT - 1;
                    TXD <= BUFFER[0];
                    BUFFER <= {1'B0, BUFFER[9:1]};
                    STAR <= (COUNT==1)? S1 : S4;
                end
        endcase
endmodule