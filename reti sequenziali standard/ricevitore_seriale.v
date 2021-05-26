// il clock del ricevitore è per ipotesi 16 volte più veloce 
// del tempo di bit(tempo che ci mette il trasmettitore a mandarmi un bit)

module ricevitore (
    reset_, clock,
    rxd,
    dav_, byte
);
    input reset_, clock;
    input rxd;
    output dav_;
    output [7:0] byte;

    reg DAV; assign dav_ = DAV;
    reg [3:0] COUNT;
    reg [4:0] WAIT;
    reg [7:0] BUFFER; assign byte = BUFFER;

    reg[1:0] STAR; parameter S0=0, S1=1, Wbit=2, Wstop=3;
    
    always @(reset_==0) #1
        begin
            DAV <= 1;
            STAR <= S0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    DAV <= 1;
                    COUNT <= 8;
                    WAIT <= 23;
                    STAR <= (rxd==0)? Wbit : S0;    // start_bit = 0
                end
            Wbit:                       // devo attendere 3/2T dopo il bit di start 
                begin
                    WAIT <= WAIT - 1;
                    STAR <= (WAIT==1)? S1 : WBit;
                end
            S1:                         // per gli altri invece devo attendere T
                begin
                    COUNT <= COUNT - 1;
                    WAIT <= 15;
                    BUFFER <= {rxd, BUFFER[7:1]};
                    STAR <= (COUNT==1)? Wstop : Wbit;
                end
            Wstop:
                begin
                    DAV <= 0;
                    WAIT <= WAIT - 1;
                    STAR <= (WAIT==1)? S0 : Wstop;
                end
        endcase
endmodule