create trigger ACCETTAZIONE_ORDINE
    before insert
    on PRODOTTO_ORDINE
    for each row
DECLARE
    qtadisp MODELLO_DEP_NEG.QUANTITA_D%TYPE;
    qtaord INT;
    qtanondisp exception;

BEGIN
--Query per prendere le quantità disponibili
  select QUANTITA_D into qtadisp
  from MODELLO_DEP_NEG
  where NOME_PROD = :new.NOME_PROD and ID_NEGOZIO = :new.ID_NEGOZIO;
--
qtaord := :new.QTA_PROD;
--
    if (qtadisp >= qtaord) then
        update MODELLO_DEP_NEG
        set QUANTITA_D = QUANTITA_D-qtaord
        where ID_NEGOZIO = :new.ID_NEGOZIO and NOME_PROD = :new.NOME_PROD;
        else
       raise qtanondisp;
    end if;


  exception
        when no_data_found then
     delete from ordine
    where ID_ORDINE = :new.ID_ORDINE;
     raise_application_error(-8,'Errore, impossibile inserire Ordine, prodotto non disponibile');

     when qtanondisp then
     delete from ordine
    where ID_ORDINE = :new.ID_ORDINE;
     raise_application_error(-5,'Errore, impossibile inserire Ordine,quantita prodotti richiesti non disponibile');
end;


