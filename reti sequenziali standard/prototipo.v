module moduleName (
    reset_, clock,
);
    input reset_, clock;

    reg[2:0] STAR; parameter S0=0, S1=1, S2=2, S3=3, S4=4;
    
    always @(reset_==0) #1
        begin
        end
    always @(posedge clock) if(reset_==1) #3
        casex(STAR)
            S0:
                begin
                end
            S1:
                begin
                end
            S2:
                begin
                end
            S3:
                begin
                end
            S4:
                begin
                end
        endcase
endmodule