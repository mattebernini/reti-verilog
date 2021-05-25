/*
    EPROM 2^8 x 4bit --> 8 fili di ind. 4 fili di dati
    64 segnali in gruppi di 4 celle consecutive --> ogni segnale sta in 4  celle
    es. 
        00000000 contiene V[0]
        00000001 contiene V[1]
        00000010 contiene T[0]
        00000011 contiene T[1]
*/

module ABC (
    reset_, clock, data,
    addr, s_, mr_, out 
);
    input reset_, clock;
    input [3:0] data;
    output s_, mr_;
    output [6:0] out;
    output[7:0] addr;

    reg[7:0] V;
    reg[7:0] T;
    reg[6:0] COUNT;
    reg[2:0] OUT; assign out = OUT;
    reg S; assign s_ = S;
    reg MR; assign mr_ = MR;
    reg[7:0] ADDR; assign addr = ADDR;

    wire [6:0] Tc, Vc;
    CONV convV(
        .c1(V[3:0]), .c2(V[7:4]),
        .converted(Vc)
    );
    CONV convT(
        .c1(T[3:0]), .c2(T[7:4]),
        .converted(Tc)
    );

    reg[2:0] STAR; parameter S0=0, S1=1, S2=2, S3=3, S4=4;

    always @(reset_==0) #1
        begin
            COUNT <= 99;
            OUT <= 0;
            STAR <= S0;
            ADDR <= 0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    MR <= 0;
                    S <= 0;
                    COUNT <= COUNT-1;
                    ADDR <= ADDR + 1;
                    V[3:0] <= data;
                    STAR <= S1;
                end
            S1:
                begin
                    COUNT <= COUNT-1;
                    ADDR <= ADDR + 1;
                    V[7:4] <= data;
                    STAR <= S2;
                end
            S2:
                begin
                    COUNT <= COUNT-1;
                    ADDR <= ADDR + 1;
                    T[3:0] <= data;
                    STAR <= S3;
                end
            S3:
                begin
                    COUNT <= COUNT-1;
                    ADDR <= ADDR + 1;
                    T[7:4] <= data;
                    MR <= 1;
                    S <= 1;
                    STAR <= (COUNT==1)? S4 : S3;
                end
            S4:
                begin
                    OUT <= Vc;
                    COUNT <= Tc;
                    STAR <= S0;
                end
        endcase
endmodule

module CONV (
    c1, c2,
    converted
);
    input [3:0] c1, c2;
    output [6:0] converted;

    wire [7:0] m1, m2;
    mul_add_nat moltiplicatore(
        .x(c2), .y(4'B1010), .c(),
        .m(m1)
    );
    add Sommatore(
        .x(m1), .y({4'B1010, c2}), .c_in(),
        .s(m2), .c_out(), .ow()
    );
    assign converted = m2[6:0];
endmodule