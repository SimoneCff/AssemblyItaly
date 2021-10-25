CREATE OR REPLACE TRIGGER aggiunta_qta
    before insert
    on PRODOTTI_FORNITURA
    for each row

    declare
    qta int;
    qta_p int;
    noqta exception;

    begin
----seleziona quantita dell'inserimento
qta := :new.QUANTITA_FORN_PROD;

---check qta è maggiore di 1
        if(qta <1) then
        raise noqta;
        end if;
---Query per vedere quantita prodotto depositato
   select QUANTITA_COMP into qta_p
   from COMPONENTI_DEPOSITATO
   where CODICE_A_BARRE_COMP = :new.CODICE_A_BARRE_COMP;

---update quantità in magazzino
        update COMPONENTI_DEPOSITATO
        set QUANTITA_COMP = qta_P+qta
        where CODICE_A_BARRE_COMP = :new.CODICE_A_BARRE_COMP;
DBMS_OUTPUT.PUT_LINE('Componente updatata correttamente');

exception
        when noqta then
                raise_application_error(-1,'Errore,Nessuna quantità inserita');

    end;





