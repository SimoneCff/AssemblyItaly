CREATE OR REPLACE FUNCTION cbocomp (componente in varchar2)
return char
is
    cab char(15);

begin
  select CODICE_A_BARRE_COMP into cab
  from COMPONENTI
  where NOMECOMP = componente;

  return cab;
end;