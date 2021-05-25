/*
    rete sequenziale asincrona, trasparente
    ***************************************
    con c = 1 è in trasparenza --> memorizza d
    con c = 0 è in conservazione --> mantiene l'ultimo valore di d
*/

module D_latch (
    d, c, q
);
    input d, c;
    output q;

    wire s, r;
    assign s = c & d;
    assign r = ~d & c;

    latch_SR lsr(.s(s), .r(r), .q(q), .qN);

endmodule

/*
    per non avere problemi d deve stare costante per
    Thold dopo e per Tsetup prima
    che c passa da 1 a 0
*/
/*
    link per vedere la simulazione:
http://digitaljs.tilk.eu/#b8b5cb4b57634db9188e45cd1ef8df436367e3f6484edc7eee8f75e41c2a0842
*/