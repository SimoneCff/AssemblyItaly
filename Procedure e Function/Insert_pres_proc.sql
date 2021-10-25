 CREATE OR REPLACE PROCEDURE insertpresenza(idimp in char, struttura in char,tipo_struttura in char,entr in int, usc in int)
 IS
     data_en int;
     data_usc int;
     data_ogg date;
     typo varchar2(20);
begin
data_ogg:= trunc(sysdate);
--query per vedere data prevista entrata
 Select ORARIO_PREVISTO_ENT into data_en
 from PRESENZA
 where DATA_PRESENZA = data_ogg and ID_IMPIEGATO=idimp;
--query per vedere data prevista uscita
 Select ORARIO_PREVISTO_USC into data_usc
 from PRESENZA
 where DATA_PRESENZA = data_ogg and ID_IMPIEGATO=idimp;
--check se è stato rispettato entrata e uscita
 if (entr != data_en or usc != data_usc) then
     DBMS_OUTPUT.PUT_LINE('Orario Entrate e/o Uscita non rispettato');
 end if;
----rendere in lowercase il tipo struttura
select lower(tipo_struttura) into typo from dual;
----update inserimento presenza
if (typo = 'negozio') then
update PRESENZA
    set ORARIO_ENTRATA = entr,
        ORARIO_USCITA = usc,
        ID_NEGOZIO = struttura
    where ID_IMPIEGATO = idimp and DATA_PRESENZA = data_ogg;
commit;
end if;
--update in caso sia laboratorio
 if (typo = 'laboratorio') then update PRESENZA
    set ORARIO_ENTRATA = entr,
        ORARIO_USCITA = usc,
        ID_LABORATORIO= struttura
    where ID_IMPIEGATO = idimp and DATA_PRESENZA = data_ogg;
 commit;
end if;

exception
    when no_data_found then
    dbms_output.PUT_LINE('Errore, dato non trovato');
    rollback;
end;



