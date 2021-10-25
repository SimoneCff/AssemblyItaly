CREATE OR REPLACE TRIGGER check_modelli
    before update
    on MODELLO_DEP_NEG
    for each row
DECLARE
    qta int;
    random_id_num int;
    random_id char(11);
BEGIN
--Inserimento nuova quantità in qta
qta := :new.QUANTITA_D;
---Creazione id in caso di  nuova fornitura
  random_id_num := dbms_random.VALUE(10000000000,99999999999);
---Conversione di random_id in char
random_id := to_char(random_id_num);
----Check quantita
    if (qta <= 0) then
DBMS_OUTPUT.PUT_LINE('Scorte finite, richiesta rifforniture mandate');
--inserimento nuova rifornitura e prodotto di rifornimento
    insert into RIFORNIMENTO (ID_RIFORNIMENTO, DATA_SPEDIZIONE, DATA_ARRIVO, ID_NEGOZIO) values (random_id,sysdate,sysdate+7,:new.ID_NEGOZIO);
    insert into PRODOTTI_RIFORNIMENTO (NOME_PROD, ID_RIFORNIMENTO, QUANTITA_RIF) values (:new.NOME_PROD,random_id,5);
    end if;
exception
    when no_Data_found then
    raise_application_error(-2,'Errore, dato non trovato');

end;