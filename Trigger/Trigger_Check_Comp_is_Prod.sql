CREATE OR REPLACE TRIGGER check_componenti_usati_ass
    BEFORE INSERT ON COMPONENTI_USATI
    FOR EACH ROW

    DECLARE
    NOME_COMP VARCHAR2(25);
    PC VARCHAR2(25);
    tipo varchar2(25);
    componente_car varchar(25);
    hdd1 varchar(25);
    hdd2 varchar(25);
    qta_ram int;
    qta_in_uso int;
        qtaisnot exception;
        ramisnot exception;

    BEGIN
--QUERY PER PRENDERE NOME PRODOTTO
    SELECT componenti.NOMECOMP into componente_car
    FROM COMPONENTI
    WHERE CODICE_A_BARRE_COMP = :NEW.CODICE_A_BARRE_COMP;
--Query per vedere modello per assemblaggiio PC
    SELECT NOME_PROD INTO PC
    FROM ASSEMBLAGGIO
    WHERE ASSEMBLAGGIO.ID_ASSEMBLAGGIO = :NEW.ID_ASSEMBLAGGIO;
--Query per vedere tipo componente
    SELECT TIPO INTO tipo
    FROM COMPONENTI
    WHERE COMPONENTI.CODICE_A_BARRE_COMP = :NEW.CODICE_A_BARRE_COMP;

---check per vedere quale componente è
    if (tipo = 'Scheda Video') then
    select GPU into componente_car
    from CARATTERISTICHE_MODELLO
    where NOME_PROD = PC;
        if (NOME_COMP != componente_car) THEN
           RAISE qtaisnot;
        end if;

    else if (tipo='CPU') then
    select CPU into componente_car
    from CARATTERISTICHE_MODELLO
    where NOME_PROD = PC;
                if (NOME_COMP != componente_car) THEN
            RAISE qtaisnot;
        end if;
    end if;

     if (tipo='MOBO') then
    select MOBO into componente_car
    from CARATTERISTICHE_MODELLO
    where NOME_PROD = PC;
        if (NOME_COMP != componente_car) THEN
            RAISE qtaisnot;
        end if;
    end if;

    if (tipo='PSU') then
    select PSU into componente_car
    from CARATTERISTICHE_MODELLO
    where NOME_PROD = PC;
        if (NOME_COMP != componente_car)THEN
            RAISE qtaisnot;
        end if;
    end if;

    if (tipo='HDD') then
        select hdd1 into componente_car
    from CARATTERISTICHE_MODELLO
    where NOME_PROD = PC;

        select hdd2 into componente_car
    from CARATTERISTICHE_MODELLO
    where NOME_PROD = PC;

        if (hdd1 != componente_car or hdd2 != componente_car) then
        RAISE qtaisnot;
        end if;
    end if;

    if (tipo='RAM') then
        select RAM into componente_car
        from CARATTERISTICHE_MODELLO
        where NOME_PROD = PC;

        select QT_RAM into qta_ram
        from CARATTERISTICHE_MODELLO
        where NOME_PROD = PC;

        select count(CODICE_A_BARRE_COMP) into qta_in_uso
        from COMPONENTI_USATI
        where ID_ASSEMBLAGGIO = :new.ID_ASSEMBLAGGIO and CODICE_A_BARRE_COMP = :new.CODICE_A_BARRE_COMP;

            if (NOME_COMP != componente_car)THEN
            RAISE qtaisnot;
            end if;
            if (qta_in_uso>=qta_ram) then
                 RAISE ramisnot;
            end if;

    end if;

    end if;

EXCEPTION
        WHEN qtaisnot THEN
        raise_application_error(-1,'Errore, Componente non rispetta modello');

        WHEN ramisnot THEN
        raise_application_error(-7,'Errore, Violazione Limite max ram');

    end;
