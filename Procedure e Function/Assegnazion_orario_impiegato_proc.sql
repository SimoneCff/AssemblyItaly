CREATE OR REPLACE PROCEDURE ins_Rand_ore_pres (impiegato in char)
IS
       random_id_n int;
       random_id char(11);
       random_entrata_prev int;
       random_uscita_prev int;

BEGIN

FOR n IN 1..5
loop
    --creazione random id
  random_id_n := dbms_random.VALUE(10000000000,99999999999);
---Conversione di random_id in char
  random_id := to_char(random_id_n);
---Creazione orario entrata
 random_entrata_prev := DBMS_RANDOM.VALUE(8,10);
---Creazione orario uscita
 random_uscita_prev := DBMS_RANDOM.VALUE(19,21);
---inserimento in presenza
INSERT INTO PRESENZA (ID_PRESENZA, DATA_PRESENZA, ORARIO_ENTRATA, ORARIO_PREVISTO_ENT, ORARIO_USCITA, ORARIO_PREVISTO_USC, ID_NEGOZIO, ID_LABORATORIO, ID_IMPIEGATO)
            VALUES (random_id,trunc(CURRENT_DATE)+n-1,null,random_entrata_prev,null,random_uscita_prev,null,null,impiegato);
    end loop;
commit;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Errore, impiegato non trovato');
    rollback;

END;