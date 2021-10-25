CREATE OR REPLACE TRIGGER update_ordine
  before update
  on PRODOTTO_ORDINE
    for each row
    DECLARE
    TOOLATE exception;
    data_ordine date;

    BEGIN
--query per prendere ordine
 select DATA_CONSEGNA into data_ordine
from ORDINE
where ID_ORDINE = :new.ID_ORDINE;

--check per vedere data
    if(trunc(sysdate)>=trunc(data_ordine) or data_ordine is not null) then
        raise toolate;
    end if;
exception
        when no_data_found then
        raise_application_error(-5,'Errore,Dato non trovato');

        when TOOLATE then
        raise_application_error(-6,'Errore impossibile aggiornare ordine, ordine già spedito');
    end;