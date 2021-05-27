module ABC (
    reset_, clock,
    eoc1, eoc2, eoc3, x1, x2, x3, rfd,
    soc, dav_, min
);
    input reset_, clock;
    input eoc1, eoc2, eoc3, rfd;
    input [7:0] x1, x2, x3;
    output soc, dav_;
    output [7:0] min;

    reg SOC, DAV; assign soc = SOC, dav_ = DAV;
    reg [7:0] OUTR, RIS; assign min = OUTR;

    wire [7:0] ris;
    MINIMO_3 minimo(x1, x2, x3, ris);

    reg[1:0] STAR; parameter S0=0, S1=1, S2=2, S3=3;
    
    always @(reset_==0) #1
        begin
            SOC <= 0;
            DAV <= 1;
            STAR <= S0;
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                    SOC <= 1;
                    STAR <= (eoc1==0 & eoc2==0 & eoc3==0)? S1 : S0;
                end
            S1:
                begin
                    SOC <= 0;
                    RIS <= ris;
                    STAR <= (eoc1==1 & eoc2==1 & eoc3==1)? S2 : S1;
                end
            S2:
                begin
                    OUTR <= RIS;
                    DAV <= 0;
                    STAR <= (rfd==1)? S3 : S2;
                end
            S3:
                begin
                    DAV <= 1;
                    STAR <= (rfd==0)? S0 : S3;
                end
        endcase
endmodule

module MINIMO_3 (
    x1, x2, x3,
    ris
);
    input [7:0] x1, x2, x3;
    output [7:0] ris;
    
    wire b1, b2, b3;
    sottrattore s1(.x(x1), .y(x2), .b_in(1'B0), .b_out(b1));
    sottrattore s2(.x(x1), .y(x3), .b_in(1'B0), .b_out(b2));
    sottrattore s3(.x(x3), .y(x2), .b_in(1'B0), .b_out(b3));

    assign ris = ({b1, b2} == 'B11)? x1 :
                 ({b1, b3} == 'B00)? x2 :
                 ({b2, b3} == 'B01)? x3 : 'H00;
endmodule