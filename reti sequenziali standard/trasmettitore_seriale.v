
module trasmettitore (
    reset_, clock,
    byte, dav_,
    rfd, txd
);
    input reset_, clock;
    input [7:0] byte;
    input dav_;
    output rfd, txd;

    reg TXD; assign txd = TXD;
    reg RFD; assign rfd = RFD;
    reg [9:0] BUFFER;           // bit di start(=0) byte e bit di stop(=1)
    reg [3:0] COUNT;


    reg[1:0] STAR; parameter S0=0, S1=1, S2=2;
    
    always @(reset_==0) #1
        begin
            RFD <= 1;
            TXD <= 1;       // marking
            STAR <= S0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    COUNT <= 10;
                    TXD <= 1;
                    RFD <= 1;
                    BUFFER <= {1'B0, byte, 1'B1};
                    STAR <= (dav_==0)? S1 : S0;
                end
            S1:
                begin
                    RFD <= 0;
                    COUNT <= COUNT - 1;
                    TXD <= BUFFER[0];
                    BUFFER <= {1, BUFFER[9:1]};
                    STAR <= (COUNT==1)? S2 : S1;
                end
            S2:
                begin
                    STAR <= (dav_==1)? S0 : S2;
                end
        endcase
endmodule