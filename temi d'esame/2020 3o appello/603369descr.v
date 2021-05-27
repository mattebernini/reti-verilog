module ABC (
    reset_, clock,
    eoc, x,
    soc, out
);
    input reset_, clock;
    input eoc;
    input [7:0] x;
    output soc;
    output [2:0] out;

    reg SOC; assign soc = SOC;
    reg [4:0] WAIT;     // 20 = 'B10100
    reg [2:0] OUTR; assign out = OUTR;
    reg [7:0] BUFFER;
    reg [2:0] N;
    reg [3:0] COUNT;
    reg COPPIA_PRIMA;   

    reg[2:0] STAR; parameter S0=0, S1=1, S2=2, S3=3, S4=4;
    
    always @(reset_==0) #1
        begin
            SOC <= 1;
            OUTR <= 0;
            COPPIA_PRIMA <= 0;
            STAR <= S0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    SOC <= 1;
                    STAR <= (eoc==0)? S1 : S0;
                end
            S1:
                begin
                    SOC <= 0;
                    BUFFER <= x;
                    COUNT <= 8;
                    N <= 0;
                    COPPIA_PRIMA <= 0;
                    STAR <= (eoc==1)? S2 : S1;
                end
            S2:
                begin
                    COUNT <= COUNT - 1;
                    COPPIA_PRIMA <= ({BUFFER[1], BUFFER[0]}=='B00)? 1 : 0;
                    N <= ({BUFFER[1], BUFFER[0]}=='B00 & COPPIA_PRIMA==0)? N+1 : N;
                    BUFFER <= {'B1, BUFFER[7:1]};
                    STAR <= (COUNT==1)? S3 : S2;
                end
            S3:
                begin
                    OUTR <= N;
                    WAIT <= 20;
                    STAR <= S4;
                end
            S4:
                begin
                    WAIT <= WAIT - 1;
                    STAR <= (WAIT == 1)? S0 : S4;
                end
        endcase
endmodule
