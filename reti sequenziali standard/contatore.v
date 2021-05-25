module ContatoreUp_Ncifre_base2 (
    numero, clock, reset_
);
    parameter N = 4;
    input clock, reset_;
    output [N-1:0] numero;

    reg [N-1:0] OUTR; assign numero = OUTR;

    always @(reset_==0) #1 OUTR <= 0;
    always @(posedge clock) if(reset_==1) #3 OUTR <= numero + 1;
endmodule