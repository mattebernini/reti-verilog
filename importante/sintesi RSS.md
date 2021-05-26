
1) guardare ai registri operativi come registri multifunzionali
        per ogni registro operativo viene prodotta una *RC operativa* con:
        in --> *variabili di comando*, uscita dei reg operativi
        out --> stato di ingresso dei reg operativi
2) ad ogni condizione di salto di STAR assegnamo una *variabile di condizionamento* tramite la *RC di condizionamento* con:
        in --> varibili di ingresso, stato dei registri
        out --> var di cond
3) isolo la *parte controllo* (rete di Moore) che è costituita da:
        - STAR
        - var di condizionamento in input
        - var di comando in output
4) la restante parte forma la *parte operativa* che produce le uscite (RSS Mealy) ed è così fatta:
        - var di comando della PC in ingresso
        - le var di ingresso della rete originale
        - var di condizionamento in uscita (che vanno alla PC)
        - le var di uscita della rete originale

variabili di comando --> non riusare la stessa per due cose diverse!