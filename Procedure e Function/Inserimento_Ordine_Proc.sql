CREATE OR REPLACE PROCEDURE creaord (CFin in char,new_client char,nomeprodins in varchar2, negozio in char,qtaprod in int,viar in varchar,civ in int, capi in int,city in varchar,prov in varchar)
IS
    random_id_n int;
    random_id char(11);
    random_az varchar2(20);
    newclientnotspecified exception;
    newcliente varchar2(2);
    no char(2);
    si char(2);

BEGIN
--lower si o no
select lower(new_client) into newcliente from dual;
---mettere si e no
no := 'no';
si := 'si';
----Se è nuovo cliente allora inserisci nel db (nome cognome inseriti da impiegato)
    if(no = newcliente or si = newcliente) then
            if (new_client = si) then
        insert into cliente (C_F) values (Cfin);
    end if;
    else
        raise newclientnotspecified;
end if;
----Creazione id ordine
  random_id_n := dbms_random.VALUE(10000000000,99999999999);
---Conversione di random_id in char
  random_id := to_char(random_id_n);
---Selezione random corriere
SELECT * into random_az
FROM  (
    SELECT NOME_AZIENDA
    FROM   CORRIERE
    ORDER BY DBMS_RANDOM.RANDOM)
WHERE  rownum < 2;
--inserimento ordine
insert into ordine (ID_ORDINE, DATA_ACQUISTO, DATA_CONSEGNA, C_F, NOME_AZIENDA) values (random_id,sysdate,null,CFin,random_az);
--inserimento prodotto in ordine
insert into PRODOTTO_ORDINE (NOME_PROD, ID_ORDINE, QTA_PROD, ID_NEGOZIO) values (nomeprodins,random_id,qtaprod,negozio);
---inserimento via
insert into INDIRIZZO_ORDINE (ID_ORDINE, VIA, N_CIV, CAP, CITTA, PROVICIA) values (random_id,viar,civ,capi,city,prov);
commit;

    --Stampa a video la conferma--
DBMS_OUTPUT.PUT_LINE('Ordine creato corretamente,il suo id ordine e'||random_id);

exception
    when no_data_found then
    DBMS_OUTPUT.PUT_LINE('Errore, dato non trovato');
    rollback;

    when newclientnotspecified then
    DBMS_OUTPUT.PUT_LINE('Errore,Non è specificato se è un nuovo cliente (si o no)');
    rollback;
end;