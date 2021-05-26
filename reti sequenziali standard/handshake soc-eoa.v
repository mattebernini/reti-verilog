

module consumatore (
    reset_, clock,
    eoc, numero,
    soc, out 
);
    input reset_, clock;
    input eoc;             // al reset a 1 per ipotesi
    input [7:0] numero;
    output soc, out;

    reg SOC; assign soc = SOC; 
    reg [7:0] COUNT;
    reg OUTR; assign out = OUTR;

    reg[1:0] STAR; parameter S0=0, S1=1, S2=2;
    
    always @(reset_==0) #1
        begin
            STAR <= S0;
            COUNT <= 0;
            SOC <= 1;       // siamo disposti ad accettare un nuovo dato
            OUT <= 0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    OUT <= 0;
                    STAR <= (eoc==0)? S1 : S0;
                    SOC <= 1;
                end
            S1:
                begin
                    SOC <= 0;
                    COUNT <= numero;
                    STAR <= (eoc==1)? S2 : S1;
                end
            S2:
                begin
                    OUTR <= 1;
                    COUNT <= COUNT - 1;
                    STAR <= (COUNT==1)? S0 : S2;
                end
        endcase
endmodule