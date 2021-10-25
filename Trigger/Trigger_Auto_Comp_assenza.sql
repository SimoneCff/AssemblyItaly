create or replace trigger CHECK_COMPONENTI
    before update
    on COMPONENTI_DEPOSITATO
    for each row
DECLARE
    random_id_num int;
    random_id   char(11);
     qta int;
    p_iva  char(11);
    BEGIN
---Inserimento nuova quantità in qta
qta := :new.QUANTITA_COMP;
---Creazione id in caso di  nuova fornitura
  random_id_num := dbms_random.VALUE(10000000000,99999999999);
---Conversione di random_id in char
random_id := to_char(random_id_num);
---Query per prendere randomicamente un fornitore
SELECT * into p_iva
FROM  (
    SELECT p_IVA
    FROM   FORNITORE
    ORDER BY DBMS_RANDOM.RANDOM)
WHERE  rownum < 2;
----Check quantita
        if (qta <= 0) then
            DBMS_OUTPUT.PUT_LINE('Scorte finite, richiesta forniture mandate a fornitore');
            ----inserimento nuovo ordine e quantita fornitura di 7
            insert into FORNITURA (ID_ORDINE_FOR, DATA_CONSEGNA, DATA_ACQUISTO,P_IVA) values (random_id,sysdate+7,sysdate);
            insert into PRODOTTI_FORNITURA (CODICE_A_BARRE_COMP, ID_ORDINE_FOR, QUANTITA_FORN_PROD) values (:new.codice_a_barre_comp,random_id,7);
        end if;
    end;

