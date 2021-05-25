

module consumatore (
    reset_, clock,
    dav_, numero,
    rfd, out 
);
    input reset_, clock;
    input dav_;             // al reset a 1 per ipotesi
    input [7:0] numero;
    output rfd, out;

    reg RFD; assign rfd = RFD; 
    reg [7:0] COUNT;
    reg OUTR; assign out = OUTR;

    reg[1:0] STAR; parameter S0=0, S1=1, S2=2;
    
    always @(reset_==0) #1
        begin
            STAR <= S0;
            COUNT <= 0;
            RFD <= 1;       // siamo disposti ad accettare un nuovo dato
            OUT <= 0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    STAR <= (dav_==0)? S1 : S0;
                    RFD <= 1;
                    COUNT <= numero;
                    OUTR <= 0;
                end
            S1:
                begin
                    RFD <= 0;
                    OUTR <= 1;
                    COUNT <= COUNT - 1;
                    STAR <= (COUNT==1)? S2 : S1;
                end
            S2:
                begin
                    OUT <= 0;
                    STAR <= (dav_==1)? S0 : S2;                   
                end
        endcase
endmodule