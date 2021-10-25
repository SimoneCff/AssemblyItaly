CREATE OR REPLACE PROCEDURE assegnaass(giorni in int,laboratorio in char,modello in varchar2)
IS
    random_id_n int;
    random_id char(11);
BEGIN
    FOR i in 1..giorni
    loop
----Creazione id ordine
  random_id_n := dbms_random.VALUE(10000000000,99999999999);
---Conversione di random_id in char
  random_id := to_char(random_id_n);

DBMS_OUTPUT.PUT_LINE('id creat');

--Crezion assemblaggio
insert into assemblaggio (ID_ASSEMBLAGGIO, ID_LABORATORIO, DATA_ASSEMBLAGGIO, NOME_PROD) VALUES (random_id,laboratorio,trunc(CURRENT_DATE+i),modello);
        end loop;
    commit;
    exception
    when no_data_found then
    dbms_output.PUT_LINE('Errore,Dato non trovato');
    rollback;
end;