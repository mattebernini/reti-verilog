/*
    rete sequenziale asincrona, NON trasparente
    versione master-slave
    ***************************************
    quando p va da 0 a 1 campiona d e lo mantiene
    altrimenti conserva
*/

module D_flip_flop (
    p, d, q
);
    input p, d;
    output q;

    wire c1, d1;
    assign c1 = ~p;

    D_latch master(.d(d), .c(c1), .q(d1));
    D_latch slave(.d(d1), .c(p), .q(q));
endmodule

/*
    d deve mantenersi per Tsetup prima e Thold dopo
    il fronte di salita di p.
    q cambia dopo Tprop rispetto al fronte di salita di p 
*/
/*
    link per vedere la simulazione:
    http://digitaljs.tilk.eu/#b8b5cb4b57634db9188e45cd1ef8df436367e3f6484edc7eee8f75e41c2a0842
*/