---- Annullamento Ordine Cliente----
CREATE OR REPLACE PROCEDURE annullaord (ID_ordine_ann in char, CFut in char)
IS
--Declare
    data_consegna_ip date;
    cfordine char(16);
    datetoolate exception;
    cfdiverso exception;

begin

    -- Trovare cf ordine--
    SELECT C_F INTO cfordine
    FROM ORDINE
    WHERE ID_ORDINE = ID_ordine_ann;


    -- vedere se ordine appartiene al cliente
    IF (cfordine != CFut) THEN
        raise cfdiverso;
    end if;

    -- PRENDERE DATA DELL'ORDINE --
    SELECT DATA_CONSEGNA INTO data_consegna_ip
    from ORDINE
    Where id_ordine = ID_ordine_ann;

    -- controlla che la data dell'annullamento non sia quella della consegna o dopo--
    IF (SYSDATE>=data_consegna_ip) THEN
     raise datetoolate;
    end if;


    -- togli prodotti dall'ordine annullato--
    DELETE FROM PRODOTTO_ORDINE
        WHERE ID_ORDINE = ID_ordine_ann;

        --Toglie indirizzo ordine
    DELETE FROM INDIRIZZO_ORDINE
     WHERE ID_ORDINE = ID_ordine_ann;

    -- annula ordine--
    DELETE FROM ORDINE
        WHERE ID_ORDINE = ID_ordine_ann;


    --Stampa a video la conferma--
DBMS_OUTPUT.PUT_LINE('Ordine annullato corretamente');
commit;


EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Errore, dato non trovato');
    rollback;

    when datetoolate then
    DBMS_OUTPUT.PUT_LINE('Errore,Impossibille annulare ordine, ordine in arrivo oggi o superamento data consegna');
    rollback;

    when cfdiverso then
    DBMS_OUTPUT.PUT_LINE('Errore,Codice fiscale non uguale a quello dell''ordine');
    rollback;
END;
