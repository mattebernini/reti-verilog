/*
    rete sequenziale asincrona, trasparente
    ***************************************
    s   r   effetto
    1   0   setta q = 1
    1   0   resetta q = 0
    0   0   conserva q = q
    1   1   inconsistente mette q = qN = 0
*/
module latch_SR(
    s, r, q, qN 
);
    input s, r;
    output q, qN;

    assign #1 q = ~(r | qN);   // r nor qN
    assign #1 qN = ~(s | q);   // s nor q
endmodule

/*
    - elemento di memoria di base
    - funziona anche con transizioni multiple perchè
*/
/*
    link per vedere la simulazione:
    http://digitaljs.tilk.eu/#b8b5cb4b57634db9188e45cd1ef8df436367e3f6484edc7eee8f75e41c2a0842
*/