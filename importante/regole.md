se in uno stato Si inizializzo un registro a k e in St lo decremento e per uscire testo se il valore è pari a jm il numero di cicli dello stato St è k-j+1.

Si:
    begin
        COUNT <= k;
        STAR <= St;
    end
St:
    begin
        COUNT <= COUNT - 1;
        STAR <= (COUNT == j)? Spoi : St;
    end
Spoi:
    begin
        ...
    end

sta k-j+1 cicli nello stato St.