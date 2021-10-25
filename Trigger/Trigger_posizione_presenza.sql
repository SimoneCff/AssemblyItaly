CREATE OR REPLACE TRIGGER posizione_presenza
    before INSERT
    ON  PRESENZA FOR EACH ROW
DECLARE
 TUTTIEDUE EXCEPTION ;

BEGIN
         if(:new.ID_Negozio is NOT null and :new.ID_LABORATORIO is NOT NULL) then
            RAISE TUTTIEDUE;
    else
         DBMS_OUTPUT.PUT_LINE('Inserito con successo Presenza');
         END IF;



    EXCEPTION
    WHEN TUTTIEDUE THEN
    raise_application_error(-20000,'Errore, impossibile inserire presenza in entrambi i luoghi');

end;


