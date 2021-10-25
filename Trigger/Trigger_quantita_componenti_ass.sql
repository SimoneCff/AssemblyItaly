create or replace trigger Controllo_Quantita_Comp_Ass
BEFORE INSERT ON COMPONENTI_USATI
FOR EACH ROW

    DECLARE
        comp_q int;
        Compiszero exception;
     BEGIN

    ---Select per visualizzare quantita componente
        select Quantita_comp into comp_q
        from COMPONENTI_DEPOSITATO
        where CODICE_A_BARRE_COMP = :new.CODICE_A_BARRE_COMP;

    --- Controllo disponibilità prodotto
        if (comp_q <= 0) then
        raise Compiszero;
        end if;

    --- Update quantita componente
        update COMPONENTI_DEPOSITATO
            SET QUANTITA_COMP = COMP_Q-1
            WHERE CODICE_A_BARRE_COMP= :new.CODICE_A_BARRE_COMP;

    EXCEPTION
        WHEN Compiszero then
                raise_application_error(-5,'Errore, Prodotto non disponibile');

    end;

