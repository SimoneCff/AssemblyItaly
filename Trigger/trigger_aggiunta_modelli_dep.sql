CREATE OR REPLACE TRIGGER Agg_modelli_dep
    BEFORE INSERT or update
    ON PRODOTTI_RIFORNIMENTO
    FOR EACH ROW

    DECLARE
    QTA_N int;
    qta_old int;
    ID_NEG_PRO CHAR(11);
    nome_prod_prs varchar(25);
    qtanot exception;

    BEGIN
 qta_N := :new.QUANTITA_RIF;
 nome_prod_prs := null;
 -----------check quantita è maggiore di 1
    if (QTA_N<1) then
        raise qtanot;
    end if;
------- Query per prendere id_negozio rifornimento
    select ID_NEGOZIO into ID_NEG_PRO
    from RIFORNIMENTO
    where ID_RIFORNIMENTO = :new.ID_RIFORNIMENTO;
---Query per selezionare vecchia quantita
    select QUANTITA_D into qta_old
    from MODELLO_DEP_NEG
    where NOME_PROD = :new.NOME_PROD and ID_NEGOZIO = ID_NEG_PRO;
    -- se e presente fare l'update
    update MODELLO_DEP_NEG
    set QUANTITA_D = qta_old+QTA_N
    where NOME_PROD = :new.NOME_PROD AND ID_NEGOZIO = ID_NEG_PRO;

exception
when no_data_found then
    --non è presente in negozio il modello, quindi si aggiunge
           insert into MODELLO_DEP_NEG (ID_NEGOZIO, NOME_PROD, QUANTITA_D) VALUES (ID_NEG_PRO,:new.NOME_PROD,QTA_N);

when qtanot then
        raise_application_error(-1,'Erorre, nessuna quantità inserita');
           end;
