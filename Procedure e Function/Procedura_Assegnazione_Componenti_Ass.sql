CREATE OR REPLACE PROCEDURE assegna_comp_ass(id_ass in char,modello in varchar2)
IS
    RAMe varchar2(30); QTe_RAM int; GPUe varchar2(30);
    CPUe varchar2(30); PSUe varchar2(30); MOBOe varchar2(30);
    HDD1 VARCHAR2(50); HDD2 VARCHAR2(50);
    data date; nodate exception; nomodel exception; model varchar(25);

BEGIN
--prende data id_assemblaggio
select DATA_ASSEMBLAGGIO into data
from ASSEMBLAGGIO
where ID_ASSEMBLAGGIO = id_ass;
--chek per vedere se data coincide con oggi
if (trunc(data)!=trunc(sysdate)) then
    raise nodate;
end if;
---Prende modello da id_assemblaggio
select NOME_PROD into model
from ASSEMBLAGGIO
where ID_ASSEMBLAGGIO = id_ass;
--check per vedere se modello coincide
if (model != modello) then
    raise nomodel;
end if;

----Inserimento pezzi pc del modello nella lista dei pezzi usati
select GPU into GPUe
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(GPUe));


select CPU into CPUe
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(CPUe));


select PSU into PSUe
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(PSUe));


select MOBO into MOBOe
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(MOBOe));


select MEMORIA_PC1 into HDD1
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(HDD1));

select MEMORIA_PC2 into hdd2
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(HDD2));


--RAM
select QT_RAM into QTe_RAM
FROM CARATTERISTICHE_MODELLO
WHERE NOME_PROD = modello;

SELECT RAM into RAMe
FROM CARATTERISTICHE_MODELLO
where NOME_PROD = modello;
for i in 1..QTe_ram
loop
insert into COMPONENTI_USATI (ID_ASSEMBLAGGIO, CODICE_A_BARRE_COMP) VALUES (id_ass,CBOCOMP(Rame));
    end loop;
commit;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Errore, Nessun Dato Trovato');
    rollback;
end;