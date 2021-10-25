
CREATE TABLE Fornitore (   
p_iva CHAR (11) PRIMARY KEY,   
CognomeFor VARCHAR2 (10),   
NomeFor VARCHAR2 (10)   
);

CREATE TABLE Contatti_For (   
Num_Tel int,   
Email VARCHAR2 (25),   
p_iva CHAR (11) NOT NULL,   
CONSTRAINT fk_contatti

FOREIGN KEY (p_iva) REFERENCES Fornitore(p_iva)   
);

CREATE TABLE Fornitura (
ID_Ordine_For char(11) PRIMARY KEY,
Data_Consegna date NOT NULL,
Data_Acquisto date NOT NULL,
P_Iva char(11) not null,

CONSTRAINT ck_data
CHECK (Data_Consegna > Data_Acquisto),
CONSTRAINT fk_piva FOREIGN KEY (P_Iva) REFERENCES FORNITORE(p_iva)
);

CREATE TABLE Componenti (
Codice_a_barre_comp CHAR(15) PRIMARY KEY,
NomeComp VARCHAR2(25),
Qualità VARCHAR2(15),
tipo varchar2(15)
);

CREATE TABLE Prodotti_Fornitura (
Codice_a_barre_comp char(15) not null,
ID_Ordine_For char(11) not null,
quantita_forn_prod int,

CONSTRAINT fk_compe FOREIGN KEY (Codice_a_barre_comp) REFERENCES Componenti(Codice_a_barre_comp),
CONSTRAINT fk_ordine_forwe FOREIGN KEY (ID_Ordine_For) REFERENCES Fornitura(ID_Ordine_For)
);

CREATE TABLE Magazzino(  
ID_Magazzino CHAR(11) PRIMARY KEY,  
Num_Scaffali int CHECK(Num_Scaffali>0),  
Num_Reparti int CHECK(Num_Reparti>0)
);



CREATE TABLE Componenti_Depositato(
Codice_a_barre_comp char(15),
reparto varchar2(20),
quantita_comp int,
ID_Magazzino CHAR(11),

CONSTRAINT fk_magazzino FOREIGN KEY (ID_Magazzino) REFERENCES Magazzino(ID_Magazzino),
CONSTRAINT fk_comp FOREIGN KEY (Codice_a_barre_comp) REFERENCES Componenti(Codice_a_barre_comp)
);


CREATE TABLE Laboratorio(
ID_Laboratorio char(11) PRIMARY KEY,
Num_Reparti int,
Occupazione varchar2(25)
);

CREATE TABLE Modello(
Nome_Prod VARCHAR2(25) PRIMARY KEY,
Prezzo number,  
Tipo varchar2(25)
);

CREATE TABLE Caratteristiche_Modello(
Nome_Prod varchar(25) not null,
RAM varchar2(30),
QT_Ram int,
GPU varchar2(30),
CPU varchar2(30),
Psu varchar2(30),
Mobo varchar2(30),
Memoria_PC1 varchar2(50),
Memoria_PC2 varchar2(50),

CONSTRAINT fK_model FOREIGN KEY (Nome_Prod) REFERENCES Modello(Nome_Prod)
);


CREATE TABLE Assemblaggio(
ID_Assemblaggio CHAR(11) PRIMARY KEY,
ID_Laboratorio char(11) Not Null,
Data_Assemblaggio Date,
Nome_Prod varchar2(25) not null,

CONSTRAINT fk_modelloS FOREIGN KEY (Nome_Prod) REFERENCES MODELLO(Nome_Prod),
CONSTRAINT fk_lab FOREIGN KEY (ID_Laboratorio) REFERENCES Laboratorio(ID_Laboratorio)

);

CREATE TABLE Componenti_Usati(
ID_Assemblaggio CHAR(11) NOT NULL,
codice_a_barre_comp CHAR(15) NOT NULL,


CONSTRAINT fk_assemblaggio FOREIGN KEY (ID_Assemblaggio) REFERENCES Assemblaggio(ID_Assemblaggio)

);

CREATE TABLE Negozio( 
ID_Negozio CHAR(11) PRIMARY KEY, 
via varchar2 (25),
n_civ int,
cap int,
citta varchar2(25),
provicia varchar2(2)
);

CREATE TABLE Contatti_Neg (  
Num_Tel int,  
Email VARCHAR (25),  
ID_Negozio CHAR (11) NOT NULL,  
CONSTRAINT fk_negozio  FOREIGN KEY (ID_Negozio) REFERENCES Negozio(ID_Negozio)
);

CREATE TABLE Rifornimento (
ID_Rifornimento char(11) PRIMARY KEY,
Data_Spedizione date,
Data_Arrivo date,
ID_Negozio char(11) not null,

CONSTRAINT fk_negozioZ  FOREIGN KEY (ID_Negozio) REFERENCES Negozio(ID_Negozio),
CONSTRAINT ck_date_arr CHECK(Data_Arrivo > Data_Spedizione)
);

CREATE TABLE Prodotti_Rifornimento (
Nome_prod varchar(25) Not Null,
ID_Rifornimento char(11) Not Null,
quantita_rif int not null,

CONSTRAINT fk_rif FOREIGN KEY (ID_Rifornimento) REFERENCES Rifornimento(ID_Rifornimento),
CONSTRAINT fk_prod FOREIGN KEY (Nome_prod)  REFERENCES Modello(Nome_prod)
);

CREATE TABLE Modello_dep_neg (
ID_Negozio char(11) not null,
Nome_prod varchar2(25) not null,
quantita_d int,

CONSTRAINT fk_prodct FOREIGN KEY (Nome_prod)  REFERENCES Modello(Nome_prod) ,
CONSTRAINT fk_negozios  FOREIGN KEY (ID_Negozio) REFERENCES Negozio(ID_Negozio)
);

CREATE TABLE Impiegato( 
ID_Impiegato char(11) PRIMARY KEY, 
Nome_imp varchar2(15), 
Cognome_imp varchar2(15), 
Ruolo varchar2(15) 
);

CREATE TABLE Presenza(
ID_Presenza char(11) PRIMARY KEY,
Data_Presenza date,
Orario_Entrata int,
Orario_Previsto_ent int,
Orario_Uscita int,
Orario_Previsto_usc int,
ID_Negozio char(11), 
ID_Laboratorio char(11), 
ID_Impiegato char(11) not null, 
 
CONSTRAINT fk_neg FOREIGN KEY (ID_Negozio) REFERENCES Negozio(ID_Negozio), 
CONSTRAINT fk_labe FOREIGN KEY (ID_Laboratorio) REFERENCES Laboratorio(ID_Laboratorio), 
CONSTRAINT fk_impe FOREIGN KEY (ID_Impiegato) REFERENCES Impiegato(ID_Impiegato),
CONSTRAINT ck_ora CHECK(Orario_Entrata<Orario_Uscita)
);

CREATE TABLE Corriere (
Nome_Azienda VARCHAR2(20) PRIMARY KEY
);

CREATE TABLE Contatti_Corr (  
Nome_Azienda VARCHAR2(20) NOT NULL,
Num_Tel int,  
CONSTRAINT fk_corr FOREIGN KEY (Nome_Azienda) REFERENCES Corriere(nome_azienda)
);

CREATE TABLE Cliente (
C_F CHAR(16) PRIMARY KEY,
Nome varchar2(15),
Cognome varchar2(15)
);

CREATE TABLE Contatti_Cliente(
C_F CHAR(16) NOT NULL,
Email varchar(20),
Num_tel int,
CONSTRAINT fk_Cf FOREIGN KEY (C_F) REFERENCES Cliente(C_F)
);

CREATE TABLE Ordine (   
ID_Ordine CHAR(11) PRIMARY KEY,   
Data_Acquisto Date,   
Data_Consegna Date,
C_F char(16),
Nome_Azienda VARCHAR2(20) NOT NULL,

CONSTRAINT fk_corrord FOREIGN KEY (Nome_Azienda) REFERENCES Corriere(Nome_Azienda),
CONSTRAINT ck_date_ordine CHECK(Data_Consegna > Data_Acquisto),
CONSTRAINT fk_clienteSE FOREIGN KEY (C_F) REFERENCES Cliente(C_F)
);

CREATE TABLE Indirizzo_Ordine (
ID_Ordine char(11) not null,
via varchar2 (25),
n_civ int,
cap int,
citta varchar2(25),
provicia varchar2(2)    ,
CONSTRAINT fk_ordineprode FOREIGN KEY (ID_Ordine) REFERENCES Ordine(ID_Ordine)
);

CREATE TABLE Prodotto_Ordine (   
Nome_prod varchar(25) Not Null,
ID_Ordine CHAR(11) NOT NULL,
Qta_prod int,
ID_Negozio char(11) not null,
CONSTRAINT fk_prodottor FOREIGN KEY (Nome_prod) REFERENCES Modello(nome_prod),
CONSTRAINT fk_ordineprod FOREIGN KEY (ID_Ordine) REFERENCES Ordine(ID_Ordine),
CONSTRAINT ck_num CHECK(Qta_prod<=3),
CONSTRAINT fk_negoziore foreign key (ID_Negozio) references  NEGOZIO(ID_Negozio)
);
