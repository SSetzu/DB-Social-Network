SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 1;
SET GLOBAL EVENT_SCHEDULER = ON;

BEGIN;
DROP DATABASE IF EXISTS ProgettoDB;
COMMIT;

BEGIN;
CREATE DATABASE ProgettoDB;
COMMIT;

USE ProgettoDB;




	-- CREAZIONE TABELLE -- 




	-- TABELLA UTENTE --

DROP TABLE IF EXISTS Utente;
CREATE TABLE Utente 
(
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
	Nome VARCHAR(15) NOT NULL,
    Cognome VARCHAR(15) NOT NULL,
	Password VARCHAR(64) NOT NULL,
    Email VARCHAR(40) NOT NULL,
    DataNascita DATE,
    CittaNatale VARCHAR(20),
    CittaResidenza VARCHAR(20),
    Nazionalita VARCHAR(4) NOT NULL,
	
    PRIMARY KEY (ID),
    UNIQUE (Email)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA TEMA --

DROP TABLE IF EXISTS Tema;
CREATE TABLE Tema
(
	 Nome VARCHAR(15) NOT NULL,
	 
	 PRIMARY KEY (Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA CONTATTO --

DROP TABLE IF EXISTS Contatto;
CREATE TABLE Contatto 
(
	Utente INT UNSIGNED NOT NULL,
    Nome VARCHAR(30) NOT NULL,
    Indirizzo VARCHAR(50) NOT NULL,
	
    PRIMARY KEY (Utente, Nome),
    FOREIGN KEY (Utente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE    
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA EVENTO --

DROP TABLE IF EXISTS Evento;
CREATE TABLE Evento
(
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
	Nome VARCHAR(25) NOT NULL, 
	Descrizione VARCHAR(255),
	Luogo VARCHAR(15) NOT NULL,
	DataOra TIMESTAMP NOT NULL,
	Organizzatore INT UNSIGNED NOT NULL,
	 
	PRIMARY KEY (ID),
    FOREIGN KEY (Organizzatore) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA GRUPPO --

DROP TABLE IF EXISTS Gruppo;
CREATE TABLE Gruppo
(
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
	Nome VARCHAR(20) NOT NULL,
    Tema VARCHAR(15) NOT NULL,
    Descrizione VARCHAR(255) NOT NULL,
    Visibilita ENUM ('Pubblico', 'Privato') NOT NULL DEFAULT 'Pubblico',
    Amministratore INT UNSIGNED NOT NULL,
	 
	PRIMARY KEY (ID),
    UNIQUE (Nome, Amministratore),
    FOREIGN KEY (Tema) REFERENCES Tema(Nome) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Amministratore) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA RACCOLTA --

DROP TABLE IF EXISTS Raccolta;
CREATE TABLE Raccolta
(
	Nome VARCHAR(30) NOT NULL,
    DataCreazione TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Visibilita ENUM ('Pubblico', 'Privato') NOT NULL DEFAULT 'Pubblico',
    Proprietario INT UNSIGNED NOT NULL,
	Tipo ENUM ('G', 'E', 'U') NOT NULL,

	PRIMARY KEY (Nome, Proprietario, Tipo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA AMICIZIA --

DROP TABLE IF EXISTS Amicizia;
CREATE TABLE Amicizia 
(
	 Mittente INT UNSIGNED NOT NULL,
	 Destinatario INT UNSIGNED NOT NULL,
	 DataOra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	 Stato ENUM ('Ignorato', 'Accettato') NOT NULL DEFAULT 'Ignorato',
     Visibilita ENUM ('Bloccato', 'Pubblico', 'Privato') NOT NULL DEFAULT 'Pubblico',
     DataUltimaSegnalazione DATE NULL DEFAULT NULL,
     NumSegnalazioni TINYINT NOT NULL DEFAULT 0,
	 
	 PRIMARY KEY (Mittente, Destinatario),
     FOREIGN KEY (Mittente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
     FOREIGN KEY (Destinatario) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA MESSAGGIO --

DROP TABLE IF EXISTS Messaggio;
CREATE TABLE Messaggio 
(
	 Mittente INT UNSIGNED NOT NULL,
	 Destinatario INT UNSIGNED NOT NULL,
	 DataOra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	 Testo VARCHAR(255) NOT NULL,
	 
	 PRIMARY KEY (Mittente, DataOra),
     FOREIGN KEY (Mittente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
     FOREIGN KEY (Destinatario) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA PARTECIPAZIONE A GRUPPO --

DROP TABLE IF EXISTS PartecipazioneG;
CREATE TABLE PartecipazioneG
(
	Gruppo INT UNSIGNED NOT NULL,
    Utente INT UNSIGNED NOT NULL,
    Stato ENUM('Accettata', 'In sospeso') NOT NULL DEFAULT 'In sospeso',
    
    PRIMARY KEY (Gruppo, Utente),
    FOREIGN KEY (Gruppo) REFERENCES Gruppo(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Utente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA PARTECIPAZIONE AD EVENTO --

DROP TABLE IF EXISTS PartecipazioneE;
CREATE TABLE PartecipazioneE
(
	Evento INT UNSIGNED NOT NULL,
    Utente INT UNSIGNED NOT NULL,
    Stato ENUM('Accettata', 'Rifiutata', 'In sospeso') NOT NULL DEFAULT 'In sospeso',
    
    PRIMARY KEY (Evento, Utente),
    FOREIGN KEY (Evento) REFERENCES Evento(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Utente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA ALLESTIMENTO --

DROP TABLE IF EXISTS Allestimento;
CREATE TABLE Allestimento
(
	Evento INT UNSIGNED NOT NULL,
	Oggetto VARCHAR(20) NOT NULL,
    Quantita MEDIUMINT NOT NULL,
	 
	PRIMARY KEY (Evento, Oggetto),
    FOREIGN KEY (Evento) REFERENCES Evento(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA SONDAGGIO --

DROP TABLE IF EXISTS Sondaggio;
CREATE TABLE Sondaggio
(
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
	Autore INT UNSIGNED NOT NULL,
    Domanda VARCHAR(99) NOT NULL,
    Scadenza TIMESTAMP NULL DEFAULT NULL,
	Raccolta VARCHAR(30) DEFAULT 'Pubblica',
	Destinatario INT UNSIGNED NOT NULL,
	Tipo ENUM ('G', 'E', 'U') NOT NULL,

    PRIMARY KEY (ID),
    FOREIGN KEY (Autore) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Raccolta, Destinatario, Tipo) REFERENCES Raccolta(Nome, Proprietario, Tipo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA OPZIONE --

DROP TABLE IF EXISTS Opzione;
CREATE TABLE Opzione
(
	Numerazione INT UNSIGNED NOT NULL,
	Sondaggio INT UNSIGNED NOT NULL,
    Testo VARCHAR(30) NOT NULL,
    NumeroRisposte MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
	 
	PRIMARY KEY (Numerazione, Sondaggio),
    FOREIGN KEY (Sondaggio) REFERENCES Sondaggio(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA RISPOSTA --

DROP TABLE IF EXISTS Risposta;
CREATE TABLE Risposta
(
 	Sondaggio INT UNSIGNED NOT NULL,
    Utente INT UNSIGNED NOT NULL,
    Opzione INT UNSIGNED NOT NULL,
    
    PRIMARY KEY (Sondaggio, Utente),
    FOREIGN KEY (Utente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
 	FOREIGN KEY (Opzione, Sondaggio) REFERENCES Opzione(Numerazione, Sondaggio) ON DELETE CASCADE ON UPDATE CASCADE       
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA CONTENUTO --

DROP TABLE IF EXISTS Contenuto;
CREATE TABLE Contenuto
(
	Percorso VARCHAR(80) NOT NULL,
	Formato VARCHAR(4) NOT NULL,
    
    PRIMARY KEY (Percorso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA POST --

DROP TABLE IF EXISTS Post;
CREATE TABLE Post
(
	ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Mittente INT UNSIGNED NOT NULL,
    DataOra TIMESTAMP NOT NULL,
    Testo VARCHAR(255) DEFAULT NULL,
    Allegato VARCHAR(80) DEFAULT NULL,
    Raccolta VARCHAR(30) DEFAULT 'Pubblica',
	Destinatario INT UNSIGNED NOT NULL,
	Tipo ENUM ('G', 'E', 'U') NOT NULL,
    MiPiace INT UNSIGNED NOT NULL DEFAULT 0,
	
	PRIMARY KEY (ID),
    UNIQUE (Mittente, DataOra),
    FOREIGN KEY (Mittente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Raccolta, Destinatario, Tipo) REFERENCES Raccolta(Nome, Proprietario, Tipo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Allegato) REFERENCES Contenuto(Percorso) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA COMMENTO --

DROP TABLE IF EXISTS Commento;
CREATE TABLE Commento
(
	DataOra TIMESTAMP NOT NULL,
    Autore INT UNSIGNED NOT NULL,
    Post INT UNSIGNED NOT NULL,
    Testo VARCHAR(255) NOT NULL,
    
    PRIMARY KEY (DataOra, Autore),
    FOREIGN KEY (Autore) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Post) REFERENCES Post(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA MI PIACE --

DROP TABLE IF EXISTS MiPiace;
CREATE TABLE MiPiace
(
    Post INT UNSIGNED NOT NULL,
    Autore INT UNSIGNED NOT NULL,
	DataOra TIMESTAMP NOT NULL,
    
    PRIMARY KEY (Post, Autore),
    FOREIGN KEY (Post) REFERENCES Post(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE    
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA TAG --

DROP TABLE IF EXISTS Tag;
CREATE TABLE Tag
(
    Post INT UNSIGNED NOT NULL,
    Autore INT UNSIGNED NOT NULL,
    Taggato INT UNSIGNED NOT NULL,
    
    PRIMARY KEY (Post, Autore, Taggato),
    FOREIGN KEY (Post) REFERENCES Post(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Taggato) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA OCCUPAZIONE --

DROP TABLE IF EXISTS Occupazione;
CREATE TABLE Occupazione
(
    Utente INT UNSIGNED NOT NULL,
    Nome VARCHAR(60) NOT NULL,
    DataInizio TIMESTAMP NOT NULL,
    DataFine TIMESTAMP NULL DEFAULT NULL,
    Luogo VARCHAR(30) NOT NULL,
    
    PRIMARY KEY (Utente, Nome, DataInizio),
    FOREIGN KEY (Utente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- TABELLA INTERESSE --

DROP TABLE IF EXISTS Interesse;
CREATE TABLE Interesse
(
    Utente INT UNSIGNED NOT NULL,
    Tema VARCHAR(15) NOT NULL,
    Descrizione VARCHAR(255) DEFAULT NULL,
    
    PRIMARY KEY (Utente, Tema),
    FOREIGN KEY (Utente) REFERENCES Utente(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Tema) REFERENCES Tema(Nome) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




	-- CREAZIONE TRIGGER --




-- Gestione della registrazione di un nuovo utente --

DROP TRIGGER IF EXISTS RegistrazioneUtente;
delimiter $$
CREATE TRIGGER RegistrazioneUtente 
AFTER INSERT ON Utente FOR EACH ROW
BEGIN

	-- Trigger che inserisce l'utente stesso fra le proprie amicizie
    INSERT INTO Amicizia (Mittente, Destinatario, Stato, Visibilita) VALUES
    (NEW.ID, NEW.ID, 'Accettato', 'Privato');

	-- Trigger che inserisce le raccolte di default nell'apposita tabella --
	INSERT INTO Raccolta (Nome, DataCreazione, Visibilita, Proprietario, Tipo) VALUES
	('Pubblica', CURRENT_TIMESTAMP(), 'Pubblico', NEW.ID, 'U'),
	('Privata', CURRENT_TIMESTAMP(), 'Privato', NEW.ID, 'U');

	-- Trigger che popola la tabella Contatto con l'indirizzo Email di registrazione --
	INSERT INTO Contatto VALUES
	(NEW.ID, 'Email', NEW.Email);

END $$
delimiter ;




-- Gestione della creazione di un nuovo gruppo --

DROP TRIGGER IF EXISTS CreazioneGruppo;
delimiter $$
CREATE TRIGGER CreazioneGruppo 
AFTER INSERT ON Gruppo FOR EACH ROW
BEGIN

	-- Trigger che popola la tabella Raccolta creando la raccolta di default--
	INSERT INTO Raccolta (Nome, DataCreazione, Visibilita, Proprietario, Tipo) VALUES
	('Pubblica', CURRENT_TIMESTAMP(), 'Pubblico', NEW.ID, 'G');

	-- Trigger che inserisce automaticamente l'amministratore di un gruppo tra i suoi partecipanti --
	INSERT INTO PartecipazioneG VALUE
	(NEW.ID, NEW.Amministratore, 'Accettata');

END $$
delimiter ;




-- Gestione della creazione di un nuovo evento --

DROP TRIGGER IF EXISTS CreazioneEvento;
delimiter $$
CREATE TRIGGER CreazioneEvento 
AFTER INSERT ON Evento FOR EACH ROW
BEGIN

	-- Trigger che popola la tabella Raccolta creando la raccolta di default --
	INSERT INTO Raccolta (Nome, DataCreazione, Visibilita, Proprietario, Tipo) VALUES
	('Pubblica', CURRENT_TIMESTAMP(), 'Pubblico', NEW.ID, 'E');

	-- Trigger che inserisce automaticamente l'organizzatore di un evento tra i suoi partecipanti --
	INSERT INTO PartecipazioneE VALUE
	(NEW.ID, NEW.Organizzatore, 'Accettata');

END $$
delimiter ;




-- Gestione dell'invio di un post --

DROP TRIGGER IF EXISTS ControlloPost;
DELIMITER $$
CREATE TRIGGER ControlloPost
BEFORE INSERT ON Post FOR EACH ROW
BEGIN

-- Se il post non contiene né testo né allegato, impedisce l'invio --
IF (NEW.Testo IS NULL AND NEW.Allegato IS NULL)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Il post che stai tentando di inviare non ha alcun contenuto: prova ad inserire un testo o un allegato!";
END IF;

END $$
DELIMITER ;




-- Gestione della ridondanza MiPiace all'interno di Post --

DROP TRIGGER IF EXISTS MiPiacePost;
DELIMITER $$
CREATE TRIGGER MiPiacePost
AFTER INSERT ON MiPiace FOR EACH ROW
BEGIN

UPDATE Post
SET MiPiace = MiPiace + 1
WHERE ID = NEW.Post;

END $$
DELIMITER ;




-- Gestione dell'invio di un sondaggio --

DROP TRIGGER IF EXISTS ControlloSondaggio;
DELIMITER $$
CREATE TRIGGER ControlloSondaggio
BEFORE INSERT ON Sondaggio FOR EACH ROW
BEGIN

-- Se si tenta di pubblicare un sondaggio sul profilo di un utente che non è l'autore, corregge il destinatario impostando il codice dell'autore stesso --
IF (NEW.Tipo = 'U' AND NEW.Autore != NEW.Destinatario)
THEN SET NEW.Destinatario = NEW.Autore;
END IF;

END $$
DELIMITER ;




-- Gestione della creazione di una nuova raccolta --

DROP TRIGGER IF EXISTS ControlloProprietario;
DELIMITER $$
CREATE TRIGGER ControlloProprietario
BEFORE INSERT ON Raccolta FOR EACH ROW
BEGIN

	-- Se il proprietario definito non è consistente, impedisce l'inserimento --
	IF
	(	(	NEW.Tipo = 'G'AND 
			0 = (SELECT COUNT(*)
				FROM Gruppo
				WHERE Id = NEW.Proprietario) )
		OR

		(	NEW.Tipo = 'E' AND
			0 = (SELECT COUNT(*)
				FROM Evento
				WHERE Id = NEW.Proprietario) )
		OR

		(	NEW.Tipo = 'U' AND
			0 = (SELECT COUNT(*)
				FROM Utente
				WHERE Id = NEW.Proprietario) ) )
	
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Il proprietario definito non è presente sul database.";
	END IF;

END $$
DELIMITER ;




-- Protezione delle raccolte di default --

DROP TRIGGER IF EXISTS ProtezioneRaccolte;
DELIMITER $$
CREATE TRIGGER ProtezioneRaccolte
BEFORE UPDATE ON Raccolta FOR EACH ROW
BEGIN

	-- La modifica delle cartelle di default viene preventivamente impedita --
	IF (OLD.Nome = "Privata" OR OLD.Nome = "Pubblica")
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Non è possibile modificare le cartelle di default: puoi però crearne di nuove!";
	END IF;

END $$
DELIMITER ;




-- Gestione della cancellazione di un gruppo --

DROP TRIGGER IF EXISTS EliminaPostGruppo;
DELIMITER $$
CREATE TRIGGER EliminaPostGruppo
AFTER DELETE ON Gruppo FOR EACH ROW
BEGIN

	DELETE FROM Raccolta
	WHERE Proprietario = old.Id and Tipo = 'G';

END $$
DELIMITER ;




-- Gestione della cancellazione di un evento --

DROP TRIGGER IF EXISTS EliminaPostEvento;
DELIMITER $$
CREATE TRIGGER EliminaPostEvento
AFTER DELETE ON Evento FOR EACH ROW
BEGIN

	DELETE FROM Raccolta
	WHERE Proprietario = old.Id and Tipo = 'E';

END $$
DELIMITER ;




-- Gestione della cancellazione di un utente --

DROP TRIGGER IF EXISTS EliminaPostUtente;
DELIMITER $$
CREATE TRIGGER EliminaPostUtente
AFTER DELETE ON Utente FOR EACH ROW
BEGIN

	DELETE FROM Raccolta
	WHERE Proprietario = old.Id and Tipo = 'U';

END $$
DELIMITER ;




-- Gestione delle date e dei numeri di segnalazione al blocco di un utente --

DROP TRIGGER IF EXISTS BloccoUtente;
DELIMITER $$
CREATE TRIGGER BloccoUtente
BEFORE UPDATE ON Amicizia FOR EACH ROW
BEGIN

	IF (NEW.Visibilita = "Bloccato" AND OLD.NumSegnalazioni < 3 AND OLD.Visibilita != 'Bloccato') 
	THEN
		SET NEW.NumSegnalazioni = OLD.NumSegnalazioni + 1;
		SET NEW.DataUltimaSegnalazione = CURRENT_TIMESTAMP;
	END IF; 

END $$

DELIMITER ;




-- Applicazione dei controlli sui Tag nei Post --

DROP TRIGGER IF EXISTS ControlloTag;
DELIMITER $$
CREATE TRIGGER ControlloTag
BEFORE INSERT ON Tag FOR EACH ROW
BEGIN

	DECLARE ProprietarioBacheca INTEGER UNSIGNED;
	DECLARE TipoDestinazione ENUM ('G', 'E', 'U');
	DECLARE NomeRaccoltaPost VARCHAR(30);
	DECLARE VisibilitaPost ENUM ('Pubblico', 'Privato');
	DECLARE VisibilitaTaggato ENUM ('Pubblico', 'Privato') DEFAULT NULL;

	SET TipoDestinazione = (SELECT Tipo
							FROM Post
							WHERE NEW.Post = ID);

	SET ProprietarioBacheca = ( SELECT P.Destinatario
								FROM Post P
								WHERE NEW.Post = P.ID);

	SET NomeRaccoltaPost = (SELECT P.Raccolta
							FROM Post P
							WHERE NEW.Post = P.ID);

	IF (TipoDestinazione = 'U') THEN
    
		SET VisibilitaPost = ( SELECT R.Visibilita
								FROM Raccolta R
								WHERE R.Nome = NomeRaccoltaPost AND
								R.Proprietario = ProprietarioBacheca AND
								R.Tipo = DestinazionePost);

		SET VisibilitaTaggato = (	SELECT A.Visibilita
									FROM Amicizia A
									WHERE A.Mittente = NEW.Taggato AND
									A.Destinatario = ProprietarioBacheca);

		IF (VisibilitaTaggato = NULL OR VisibilitaTaggato <= VisibilitaPost) THEN
        
			SIGNAL SQLSTATE '45000'	SET MESSAGE_TEXT = "L'utente citato non ha la visibilità necessaria per essere taggato in questo post.";
		END IF;
	
	ELSE IF (TipoDestinazione = 'G' AND 1 !=(SELECT COUNT(*)
											FROM PartecipazioneG
											WHERE Gruppo = ProprietarioBacheca
											AND Stato = 'Accettata'
											AND Utente = NEW.Taggato)) THEN
                                            
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "L'utente citato non fa parte di questo gruppo.";
	

	ELSE IF (TipoDestinazione = 'E' AND 1 != (	SELECT COUNT(*)
												FROM PartecipazioneE
												WHERE Evento = ProprietarioBacheca
												AND Utente = NEW.Taggato)) THEN 
                                                
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "L'utente citato non è fra gli invitati a questo evento.";
	END IF;
    END IF;
    END IF;
    
END $$
DELIMITER ;




-- POPOLAMENTO DEL DATABASE --




BEGIN;
INSERT INTO Tema VALUES 
('Cinema'),
('Sport'),
('Famiglia'),
('Istruzione'),
('Casa'),
('Politica'),
('Scienze'),
('Lavoro'),
('Letteratura'),
('Intrattenimento'),
('Hobby'),
('Musica'),
('Informatica'),
('Fotografia'),
('Religione'),
('SqlInjection'),
('Viaggi');
COMMIT;




BEGIN;
INSERT INTO Utente (Nome, Cognome, Password, Email, DataNascita, CittaNatale, CittaResidenza, Nazionalita) VALUES 
('Mario', 'Rossi', 'HoTantiOmonimi', 'm.rossi@gmail.com', CURRENT_DATE() - INTERVAL 27 YEAR - INTERVAL 4 MONTH - INTERVAL 19 DAY, 'Lugano', 'Roma', 'ITA'),
('Jean', 'Default', 'TourEiffel', 'jeandef@orange.fr', CURRENT_DATE() - INTERVAL 20 YEAR - INTERVAL 11 MONTH - INTERVAL 30 DAY, 'Lione', 'Parigi', 'FRA'),
('Karl', 'Beck', 'Bundesrat', 'beckarl@gmail.com', CURRENT_DATE() - INTERVAL 35 YEAR - INTERVAL 2 MONTH - INTERVAL 3 DAY, 'Berlino', 'Berlino', 'TED'),
('Hans', 'Persson', 'Konserthuset', 'perhans@gmail.com', CURRENT_DATE() - INTERVAL 38 YEAR - INTERVAL 6 MONTH - INTERVAL 8 DAY, 'Stoccolma', 'Uppsala', 'SVE'),
('Guido', 'Palazzini', 'VilletteASchiera', 'guidopala@hotmail.it', CURRENT_DATE() - INTERVAL 45 YEAR - INTERVAL 8 MONTH - INTERVAL 23 DAY, 'Napoli', 'Napoli', 'ITA'),
('Renato', 'Palazzini', 'AppartamentiSpogli', 'palarena@hotmail.it', CURRENT_DATE() - INTERVAL 42 YEAR - INTERVAL 4 MONTH - INTERVAL 13 DAY, 'Napoli', 'Napoli', 'ITA'),
('Alessandro', 'Marinato', 'Sardine11', 'marinalex@gmail.com', CURRENT_DATE() - INTERVAL 38 YEAR - INTERVAL 7 MONTH - INTERVAL 2 DAY, 'Chieti', 'Napoli', 'ITA'),
('Michela', 'Tizia', 'morelamponi1986', 'tiziami@gmail.com', CURRENT_DATE() - INTERVAL 25 YEAR - INTERVAL 15 DAY, 'Savona', 'Savona', 'ITA'),
('Luigina', 'Grandi', 'caldofreddo', 'grandelu@hotmail.it', CURRENT_DATE() - INTERVAL 16 YEAR - INTERVAL 2 MONTH - INTERVAL 2 DAY, 'Torino', 'Milano', 'ITA'),
('Alessio', 'Simplicio', 'confucio', 'alessio.simpl@gmail.com', CURRENT_DATE() - INTERVAL 22 YEAR - INTERVAL 10 MONTH - INTERVAL 16 DAY, 'Pistoia', 'Prato', 'ITA'),
('Gennaro', 'Santo', 'SanGennà', 'sangenna@gmail.com', CURRENT_DATE() - INTERVAL 26 YEAR - INTERVAL 1 MONTH - INTERVAL 25 DAY, 'Napoli', 'Parigi', 'ITA'),
('Rebecca', 'Bianchi', 'gattini', 'r.bianchi4@live.it', CURRENT_DATE() - INTERVAL 20 YEAR - INTERVAL 10 MONTH - INTERVAL 30 DAY, 'Perugia', 'Perugia', 'ITA'),
('Annalisa', 'Perugini', 'cioccolato', 'annalisaaa@hotmail.it', CURRENT_DATE() - INTERVAL 24 YEAR - INTERVAL 5 MONTH - INTERVAL 22 DAY, 'Roma', 'Ostia', 'ITA'),
('Francesca', 'Rossi', 'forzaviola', 'f.rossi@gmail.com', CURRENT_DATE() - INTERVAL 40 YEAR - INTERVAL 7 MONTH - INTERVAL 11 DAY, 'Firenze', 'Sesto Fiorentino', 'ITA'),
('Francesco', 'Fiero', 'simpatiaportamivia', 'fierofiero@gmail.com', CURRENT_DATE() - INTERVAL 16 YEAR - INTERVAL 7 MONTH - INTERVAL 3 DAY, 'Firenze', 'Milano', 'ITA'),
('Gianpaolo', 'Medico', 'pazientejointerapia', 'gianpy@yahoo.com', CURRENT_DATE() - INTERVAL 16 YEAR - INTERVAL 9 MONTH - INTERVAL 9 DAY, 'Milano', 'Milano', 'ITA'),
('Missing', 'Name', 'H4X0R', '0@0.com', 0, '#!?', '#!?', 'ITA'),
('No', 'Name', 'H4X0R', '0@0.net', 0, '#!?', '#!?', 'ITA'),
('Giulio', 'Sensore', 'photopentax', 'giuliosens@unipi.it', CURRENT_DATE() - INTERVAL 21 YEAR - INTERVAL 2 MONTH - INTERVAL 28 DAY, 'Catania', 'Pisa', 'ITA');
COMMIT;




BEGIN;
INSERT INTO Contatto VALUES 
(1, 'Via di casa', 'Stazione Termini'),
(2, 'Maison', 'La Tour Eiffel'),
(5, 'Indirizzo', 'Via delle begonie, 4'),
(6, 'Indirizzo', 'Via delle begonie, 4'),
(11, 'Numero di cellulare', '333-7771095'),
(12, 'Ufficio', 'Piazzale degli oppressi, 322'),
(10, 'Residenza', 'Via Yin-Yang'),
(15, 'Residenza', 'Villa Splendida'),
(16, 'Dove abito:', 'Corso Ippocrate 16'),
(19, 'Il mio profilo facebook', 'https://www.facebook.com/giulio.sensore.2');
COMMIT;




BEGIN;
INSERT INTO Amicizia VALUES 
(1, 5, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 29 MINUTE, 'Accettato', 'Pubblico', NULL, 0),
(3, 6, CURRENT_TIMESTAMP() - INTERVAL 22 DAY - INTERVAL 12 HOUR - INTERVAL 9 MINUTE, 'Accettato', 'Bloccato', CURRENT_TIMESTAMP() - INTERVAL 7 DAY - INTERVAL 2 HOUR - INTERVAL 29 MINUTE, 1),
(3, 15, CURRENT_TIMESTAMP() - INTERVAL 22 DAY - INTERVAL 2 HOUR - INTERVAL 29 MINUTE, 'Accettato', 'Bloccato', CURRENT_TIMESTAMP() - INTERVAL 1 DAY - INTERVAL 1 HOUR - INTERVAL 2 MINUTE, 2),
(15, 9, CURRENT_TIMESTAMP() - INTERVAL 20 DAY - INTERVAL 29 MINUTE, 'Ignorato', 'Pubblico', NULL, 0),
(10, 13, CURRENT_TIMESTAMP() - INTERVAL 27 DAY - INTERVAL 22 HOUR - INTERVAL 29 MINUTE, 'Accettato', 'Privato', NULL, 0),
(13, 10, CURRENT_TIMESTAMP() - INTERVAL 27 DAY - INTERVAL 20 HOUR - INTERVAL 20 MINUTE, 'Accettato', 'Privato', NULL, 0),
(19, 10, CURRENT_TIMESTAMP() - INTERVAL 18 DAY - INTERVAL 2 HOUR - INTERVAL 29 MINUTE, 'Accettato', 'Pubblico', NULL, 0),
(5, 6, CURRENT_TIMESTAMP() - INTERVAL 29 DAY - INTERVAL 2 HOUR - INTERVAL 29 MINUTE, 'Accettato', 'Privato', NULL, 0),
(6, 5, CURRENT_TIMESTAMP() - INTERVAL 29 DAY - INTERVAL 2 HOUR - INTERVAL 2 MINUTE, 'Accettato', 'Privato', NULL, 0),
(11, 13, CURRENT_TIMESTAMP() - INTERVAL 19 DAY - INTERVAL 23 HOUR - INTERVAL 12 MINUTE, 'Accettato', 'Pubblico', NULL, 0),
(13, 11, CURRENT_TIMESTAMP() - INTERVAL 18 DAY - INTERVAL 2 HOUR, 'Accettato', 'Pubblico', NULL, 0);
COMMIT;




BEGIN;
INSERT INTO Messaggio VALUES 
(5, 6, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 29 MINUTE, "Creato il gruppo sul calciomercato, iscriviti! Potrebbe essere divertente. :D"),
(6, 5, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 28 MINUTE, "Fatto! Speriamo di ottenere molte iscrizioni!"),
(5, 6, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 27 MINUTE, "Per ora nulla... A lavoro tutto a posto?"),
(6, 5, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 26 MINUTE, "Tutto regolare... Ho creato un gruppo per i dipendenti, potrebbe tornarci utile!"),
(5, 6, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 25 MINUTE, "Bella idea! Ora devo andare, ci vediamo a casa stasera!"),
(6, 5, CURRENT_TIMESTAMP() - INTERVAL 17 DAY - INTERVAL 2 HOUR - INTERVAL 24 MINUTE, "A dopo! :)"),
(5, 6, CURRENT_TIMESTAMP() - INTERVAL 7 DAY, "Quel Marinato è l'unico iscritto al gruppo finora e non mi sembra molto ben informato. -_-"),
(5, 6, CURRENT_TIMESTAMP() - INTERVAL 6 DAY - INTERVAL 23 HOUR, "Già. -_-'"),
(11, 13, CURRENT_TIMESTAMP() - INTERVAL 20 DAY - INTERVAL 6 HOUR - INTERVAL 11 MINUTE, "We, ciao! Anche a te piace Star Wars, vedo! Non me lo sarei aspettato. ;)"),
(13, 11, CURRENT_TIMESTAMP() - INTERVAL 20 DAY - INTERVAL 2 HOUR - INTERVAL 46 MINUTE, "Ciao, Gennaro! Sì, sono abbastanza fissata. *_*");
COMMIT;




BEGIN;
INSERT INTO Gruppo (Nome, Tema, Descrizione, Visibilita, Amministratore) VALUES 
('Calciomercato', 'Sport', 'Il gruppo dedicato ai veri appassionati di calciomercato!', 'Pubblico', 5),
('Star Wars', 'Cinema', 'In attesa del settimo film, per non dimenticare i primi episodi!', 'Pubblico', 10),
('Database', 'Informatica', 'Per chiunque voglia parlarne o abbia bisogno di aiuto!', 'Pubblico', 6),
('Dipendenti', 'Lavoro', 'Un gruppo per persone assunte come dipendenti.', 'Privato', 12),
('Liceo', 'Istruzione', 'Qui possiamo passarci i compiti in classe ragazzi, alla faccia della Prof. Colucci!', 'Privato', 15),
('H4X0RZ', 'SqlInjection', 'SELECT * FROM user_pwd', 'Pubblico', 17),
('Pentaxiani', 'Fotografia', 'Se hai una Pentax, entra qui!', 'Pubblico', 19),
('ACF Fiorentina', 'Sport', 'Per la prima volta, la Curva Fiesole in formato digitale!', 'Pubblico', 14),
('Muse', 'Musica', 'Per tutti i fan del trio britannico!', 'Pubblico', 13),
('NaviInBottiglia', 'Hobby', 'Per chi ha molto tempo da perdere!', 'Pubblico', 16);
COMMIT;




BEGIN;
INSERT INTO PartecipazioneG VALUES 
(1, 6, 'Accettata'),
(1, 7, 'Accettata'),
(2, 3, 'Accettata'),
(2, 9, 'In sospeso'),
(2, 11, 'Accettata'),
(2, 13, 'Accettata'),
(2, 15, 'Accettata'),
(3, 9, 'Accettata'),
(3, 3, 'Accettata'),
(4, 7, 'Accettata'),
(4, 6, 'Accettata'),
(4, 9, 'Accettata'),
(4, 13, 'In Sospeso'),
(5, 9, 'Accettata'),
(5, 16, 'In Sospeso'),
(6, 18, 'Accettata'),
(7, 10, 'Accettata'),
(7, 13, 'Accettata'),
(8, 1, 'Accettata'),
(8, 19, 'Accettata'),
(8, 15, 'Accettata'),
(9, 1, 'Accettata'),
(9, 10, 'Accettata'),
(9, 15, 'Accettata');
COMMIT;




BEGIN;
INSERT INTO Evento (Nome, Descrizione, Luogo, DataOra, Organizzatore) VALUES 
("Concerto Muse", "L'evento che tutti stavamo aspettando! Ci vediamo là!", "Roma", "2015-07-18 21:00:00", 13),
("Capodanno NAPOLI", "Tutti invitati, ci vediamo in strada!", "Napoli", "2015-01-01 00:00:00", 7),
("Foreign users reunion", "For all us guys who cannot speak correctly Italian!", "Bruxelles", "2015-04-01 15:00:00", 4),
("Festa a casa Palazzini", "Per tutti i nostri amici, following e followers!", "Napoli", "2015-03-01 20:00:00", 5),
("Assemblea di classe", "Mi raccomando tutti presenti!", "Aula A23", "2015-02-14 08:10:00", 9),
("Cenone di Natale", "Per me e Renato, in pratica.", "Casa", "2014-12-25 20:00:00", 5),
("Star Wars Episodio VII", "Perché non è mai troppo presto per organizzarsi! Tutti a LOS ANGELES (supponendo che la prima sia lì).", "Hollywood", "2015-12-13 20:00:00", 10),
("Venezia 72", "Per tutti interessati al Festival del Cinema 2015!", "Venezia", "2015-09-01", 10),
("Ritrovo utenti", "Tutti a Roma!", "Roma", "2015-05-01", 10),
("Riunione di lavoro", "Tutti i dipendenti sono convocati.", "Milano", "2015-03-01", 7);
COMMIT;




BEGIN;
INSERT INTO PartecipazioneE VALUES 
(1, 1, 'Accettata'),
(1, 10, 'Accettata'),
(1, 15, 'In sospeso'),
(2, 5, 'Accettata'),
(2, 6, 'Accettata'),
(3, 2, 'Accettata'),
(3, 3, 'Accettata'),
(4, 1, 'Accettata'),
(4, 3, 'Accettata'),
(4, 6, 'Accettata'),
(5, 15, 'Rifiutata'),
(6, 6, 'Accettata'),
(7, 3, 'Accettata'),
(7, 9, 'In sospeso'),
(7, 11, 'Accettata'),
(7, 13, 'Accettata'),
(7, 15, 'Accettata'),
(8, 13, 'Accettata'),
(8, 19, 'Rifiutata'),
(9, 1, 'Accettata'),
(9, 2, 'Accettata'),
(9, 3, 'Accettata'),
(9, 4, 'In sospeso'),
(9, 5, 'Accettata'),
(9, 6, 'Accettata'),
(9, 7, 'Accettata'),
(9, 8, 'Accettata'),
(9, 9, 'Accettata'),
(9, 11, 'Accettata'),
(9, 12, 'Accettata'),
(9, 13, 'Accettata'),
(9, 14, 'In Sospeso'),
(9, 15, 'Rifiutata'),
(9, 16, 'In Sospeso'),
(9, 17, 'Accettata'),
(9, 18, 'Accettata'),
(9, 19, 'Accettata'),
(10, 6, 'Accettata'),
(10, 9, 'Accettata');
COMMIT;




BEGIN;
INSERT INTO Allestimento VALUES 
(1, "Biglietti!", 4),
(1, "CD!", 5),
(1, "Pennarelli!", 5),
(1, "Magliette!", 5),
(1, "Altro!", 5),
(2, "Razzi", 50),
(2, "Petardi", 100),
(2, "Spumante", 2),
(4, "Un dessert", 4),
(6, "Il pandoro", 1);
COMMIT;




BEGIN;
INSERT INTO Sondaggio (Autore, Domanda, Destinatario, Tipo) VALUES 
(10, 'Domandona secca! Qual è il vostro preferito?', 2, 'G'),
(13, 'Album preferito? A parte il prossimo! :)', 9, 'G'),
(13, 'Come sarà il concerto?', 1, 'E'),
(16, 'A chi piace dedicarsi alle navi in bottiglia?', 10, 'G'),
(12, 'Siete soddisfatti del vostro stipendio? >:(', 4, 'G'),
(14, 'Votate il vostro beniamino!', 8, 'G'),
(7, 'Tempo di pronostici! Chi vince il campionato?', 1, 'G'),
(10, 'J.J. Abrams alla regia vi convince?', 2, 'G'),
(17, 'Ce la faremo?', 6, 'G'),
(1, 'Allora! Che ve ne pare di questo social network?', 9, 'E');
COMMIT;




BEGIN;
INSERT INTO Opzione (Numerazione, Sondaggio, Testo) VALUES 
(1, 1, "La minaccia fantsma"),
(2, 1, "L'attacco dei cloni"),
(3, 1, "La vendetta dei Sith"),
(4, 1, "Una nuova speranza"),
(5, 1, "L'Impero colpisce ancora"),
(6, 1, "Il ritorno dello Jedi"),
(1, 2, "Showbiz"),
(2, 2, "Origin of symmetry"),
(3, 2, "Absolution"),
(4, 2, "Black holes and revelations"),
(5, 2, "The resistance"),
(6, 2, "The 2nd law"),
(1, 3, "Bello"),
(2, 3, "Bellissimo"),
(3, 3, "Ancora più bello"),
(1, 4, "A me!"),
(1, 5, "Assolutamente sì"),
(2, 5, "Più sì che no"),
(3, 5, "Più no che sì"),
(4, 5, "Assolutamente no"),
(1, 6, "Borja Valero"),
(2, 6, "Gonzalo Rodriguez"),
(3, 6, "Juan Cuadrado"),
(4, 6, "Mario Gomez"),
(1, 7, "Juventus"),
(2, 7, "Roma"),
(3, 7, "Napoli"),
(4, 7, "Altro"),
(1, 8, "Sì, sono fiducioso."),
(2, 8, "Abbastanza, ma resto scettico."),
(3, 8, "No, non è l'uomo giusto."),
(1, 9, "Sì!"),
(2, 9, "No!"),
(1, 10, "E' fantastico!"),
(2, 10, "Buono, nella media."),
(3, 10, "Ha potenziale, ma è acerbo.");
COMMIT;




BEGIN;
INSERT INTO Risposta (Sondaggio, Utente, Opzione) VALUES 
(1, 3, 1),
(1, 10, 5),
(1, 11, 5),
(1, 13, 6),
(1, 15, 5),
(2, 15, 4),
(2, 10, 4),
(2, 13, 3),
(2, 1, 2),
(3, 1, 1),
(3, 10, 2),
(3, 13, 3),
(4, 16, 1),
(5, 12, 4),
(5, 9, 2),
(5, 6, 3),
(6, 1, 4),
(6, 14, 1),
(7, 5, 3),
(7, 6, 3),
(7, 7, 3),
(8, 10, 1),
(8, 13, 1),
(8, 15, 3),
(9, 17, 1),
(9, 18, 1),
(10, 1, 1),
(10, 13, 1),
(10, 9, 1),
(10, 15, 3),
(10, 8, 2);
COMMIT;




BEGIN;
INSERT INTO Post (Mittente, DataOra, Testo, Destinatario, Tipo) VALUES 
(1, CURRENT_TIMESTAMP - INTERVAL 19 DAY - INTERVAL 3 HOUR - INTERVAL 57 MINUTE, 'Sono stato il primo a scrivere su questo Social Network, fico!', 1, 'U'),
(1, CURRENT_TIMESTAMP - INTERVAL 17 DAY - INTERVAL 7 HOUR - INTERVAL 3 MINUTE, "Era l'ora che ti iscrivessi pure tu, finalmente!", 5, 'U'),
(6, CURRENT_TIMESTAMP - INTERVAL 28 DAY - INTERVAL 6 HOUR - INTERVAL 10 MINUTE, 'Benvenuti a tutti quanti i dipendenti! :)', 4, 'G'),
(7, CURRENT_TIMESTAMP - INTERVAL 17 DAY - INTERVAL 5 HOUR - INTERVAL 37 MINUTE, 'Era da un sacco di tempo che cercavo un gruppo del genere.', 4, 'G'),
(9, CURRENT_TIMESTAMP - INTERVAL 16 DAY - INTERVAL 23 HOUR - INTERVAL 51 MINUTE, 'Come posso fare per ingannare il mio capo spacciandomi per malata?', 4, 'G'),
(12, CURRENT_TIMESTAMP - INTERVAL 16 DAY - INTERVAL 22 HOUR - INTERVAL 46 MINUTE, 'Questo posto è per gente nullafacente...', 4, 'G'),
(9, CURRENT_TIMESTAMP - INTERVAL 15 DAY - INTERVAL 4 HOUR - INTERVAL 23 MINUTE, 'Io oggi durante il mio orario lavorativo ho passato le ultime 3 ore dormendo nel ripostiglio delle scope, pensate che un datore di lavoro controlli spesso le riprese delle telecamere a circuito chiuso?', 4, 'G'),
(7, CURRENT_TIMESTAMP - INTERVAL 7 DAY - INTERVAL 1 HOUR - INTERVAL 9 MINUTE, 'Ultime notizie! Tevez al Real e Ronaldo alla Juve!', 1, 'G'),
(5, CURRENT_TIMESTAMP - INTERVAL 21 HOUR - INTERVAL 1 MINUTE, 'Dopo la scorsa sessione di mercato le milanesi sono allo sbando!', 1, 'G'),
(3, CURRENT_TIMESTAMP - INTERVAL 3 HOUR - INTERVAL 7 MINUTE, 'Ich lebe Database!', 3, 'G'),
(6, CURRENT_TIMESTAMP - INTERVAL 3 HOUR - INTERVAL 8 MINUTE, 'Benvenuti sul mio gruppo! I join anticipati sono la mia passione.', 3, 'G'),
(3, CURRENT_TIMESTAMP - INTERVAL 4 HOUR - INTERVAL 30 MINUTE, 'Ich lebe Star Wars!', 2, 'G'),
(13, CURRENT_TIMESTAMP - INTERVAL 3 HOUR - INTERVAL 7 MINUTE, 'Bello il nuovo trailer! Sarà dura resistere...', 2, 'G'),
(10, CURRENT_TIMESTAMP - INTERVAL 1 DAY - INTERVAL 3 HOUR - INTERVAL 7 MINUTE, 'Adoro la colonna sonora di questa saga, anche voi?', 2, 'G'),
(15, CURRENT_TIMESTAMP - INTERVAL 4 DAY - INTERVAL 22 HOUR - INTERVAL 18 MINUTE, 'Cancellate dalla Storia La Minaccia Fantasma!', 2, 'G'),
(3, CURRENT_TIMESTAMP - INTERVAL 4 DAY - INTERVAL 3 HOUR - INTERVAL 50 MINUTE, 'Jar-jar ist sehr sympatisch!', 2, 'G'),
(9, CURRENT_TIMESTAMP - INTERVAL 2 DAY - INTERVAL 18 HOUR - INTERVAL 45 MINUTE, "La risposta al primo esercizio è 'La Minaccia Fantasma'!", 5, 'G'),
(15, CURRENT_TIMESTAMP - INTERVAL 2 DAY - INTERVAL 18 HOUR, 'Per me è la cipolla!', 5, 'G'),
(15, CURRENT_TIMESTAMP - INTERVAL 2 DAY - INTERVAL 3 HOUR - INTERVAL 20 MINUTE, "Il compito di oggi era veramente difficile! Speriamo bene, a voi com'è andata?", 5, 'G'),
(17, CURRENT_TIMESTAMP - INTERVAL 15 MINUTE, "Questo Database Management System CADRA'!", 5, 'G'),
(17, CURRENT_TIMESTAMP - INTERVAL 5 MINUTE, 'Ok, forse è più difficile di quanto pensassi.. Lo sapevo che dovevo studiare Ingegneria!', 6, 'G'),
(19, CURRENT_TIMESTAMP - INTERVAL 15 DAY - INTERVAL 7 HOUR - INTERVAL 29 MINUTE, 'Dubbio amletico: K-50 a 500 euro o k-30 a 950? Entrambe provviste di ottica WR con corpo tropicalizzato.', 7, 'G'),
(1, CURRENT_TIMESTAMP() - INTERVAL 26 DAY - INTERVAL 28 HOUR, "Maledizione un'altra Rossi! Ma è davvero un cognome così comune? Comunque FORZA MAGGICAAA trololol", 8, 'G');
COMMIT;




BEGIN;
INSERT INTO Commento (DataOra, Autore, Post, Testo) VALUES 
(CURRENT_TIMESTAMP - INTERVAL 7 DAY - INTERVAL 2 HOUR - INTERVAL 57 MINUTE, 6, 9, "Ma lascia stare cit."),
(CURRENT_TIMESTAMP - INTERVAL 4 DAY - INTERVAL 21 HOUR - INTERVAL 29 MINUTE, 3, 15, "Ich lebe 'La minaccia fantasma'! Es ist mein lieblingsfilm!"),
(CURRENT_TIMESTAMP - INTERVAL 4 DAY - INTERVAL 21 HOUR - INTERVAL 17 MINUTE, 15, 15, "Dopo questa mi ritiro."),
(CURRENT_TIMESTAMP - INTERVAL 4 DAY - INTERVAL 21 HOUR - INTERVAL 1 MINUTE, 11, 15, "LOL"),
(CURRENT_TIMESTAMP - INTERVAL 4 MINUTE, 18, 21, "Sei il solito incompetente, lascia fare a me!"),
(CURRENT_TIMESTAMP - INTERVAL 3 MINUTE, 18, 21, "nope; DELETE FROM UTENTE WHERE Cognome = 'Name';"),
(CURRENT_TIMESTAMP - INTERVAL 2 MINUTE, 17, 21, "Menomale che l'incapace sono io, hai rischiato di cancellarci dal Social Network, c'ho messo ben 25 minuti per registrarmi!"),
(CURRENT_TIMESTAMP - INTERVAL 14 DAY - INTERVAL 20 HOUR - INTERVAL 55 MINUTE, 10, 22, "Beh, la K-50 ha sicuramente un miglior rapporto qualità prezzo, se non vuoi spendere troppo prendi quella!"),
(CURRENT_TIMESTAMP - INTERVAL 14 DAY - INTERVAL 20 HOUR - INTERVAL 45 MINUTE, 13, 22, "Ma cosa dici Alessio!? Ma quale rapporto qualità-prezzo, la K-30 surclassa sotto ogni aspetto la K-50, chi fa fotografia pensa solo al risultato finale!"),
(CURRENT_TIMESTAMP - INTERVAL 14 DAY - INTERVAL 20 HOUR - INTERVAL 45 MINUTE, 19, 22, "Non vi scaldate, avevo bisogno solo di un consiglio, grazie ad entrambi per il vostro parere!");
COMMIT;




BEGIN;
INSERT INTO MiPiace VALUES 
(2, 5, CURRENT_TIMESTAMP - INTERVAL 17 DAY - INTERVAL 7 HOUR - INTERVAL 1 MINUTE),
(3, 6, CURRENT_TIMESTAMP - INTERVAL 17 DAY - INTERVAL 6 HOUR),
(3, 7, CURRENT_TIMESTAMP - INTERVAL 16 DAY - INTERVAL 6 HOUR),
(3, 9, CURRENT_TIMESTAMP - INTERVAL 16 DAY - INTERVAL 5 HOUR - INTERVAL 15 MINUTE),
(7, 7, CURRENT_TIMESTAMP - INTERVAL 15 DAY - INTERVAL 4 HOUR - INTERVAL 2 MINUTE),
(14, 3, CURRENT_TIMESTAMP - INTERVAL 1 DAY - INTERVAL 1 HOUR - INTERVAL 17 MINUTE),
(14, 9, CURRENT_TIMESTAMP - INTERVAL 1 DAY - INTERVAL 57 MINUTE),
(14, 11, CURRENT_TIMESTAMP - INTERVAL 1 DAY - INTERVAL 56 MINUTE),
(14, 13, CURRENT_TIMESTAMP - INTERVAL 3 HOUR - INTERVAL 2 MINUTE),
(16, 3, CURRENT_TIMESTAMP - INTERVAL 2 DAY - INTERVAL 3 HOUR - INTERVAL 50 MINUTE),
(18, 9, CURRENT_TIMESTAMP - INTERVAL 2 DAY - INTERVAL 18 HOUR - INTERVAL 10 MINUTE),
(18, 16, CURRENT_TIMESTAMP - INTERVAL 2 DAY - INTERVAL 18 HOUR - INTERVAL 47 MINUTE),
(20, 18, CURRENT_TIMESTAMP - INTERVAL 15 MINUTE - INTERVAL 14 SECOND);
COMMIT;




BEGIN;
INSERT INTO Tag VALUES
(8, 5, 6),
(9, 6, 5),
(10, 9, 6),
(12, 9, 11),
(13, 9, 10),
(13, 9, 11),
(13, 9, 15),
(16, 9, 15),
(17, 9, 15),
(20, 17, 18),
(18, 9, 19),
(6, 12, 7);
COMMIT;



BEGIN;
INSERT INTO Raccolta (Nome, DataCreazione, Visibilita, Proprietario, Tipo) VALUES
("Foto del mare", CURRENT_DATE - INTERVAL 4 MONTH - INTERVAL 12 DAY - INTERVAL 18 HOUR, "Privato", 13, 'U'),
("Le mie navi in bottiglia", CURRENT_DATE - INTERVAL 1 MONTH - INTERVAL 1 DAY - INTERVAL 8 HOUR, "Pubblico", 16, 'U'),
("Le mie perle di saggezza", CURRENT_DATE - INTERVAL 2 MONTH - INTERVAL 22 DAY - INTERVAL 3 MINUTE, "Pubblico", 7, 'U'),
("Le mie canzoni", CURRENT_DATE - INTERVAL 1 MONTH - INTERVAL 12 DAY - INTERVAL 23 HOUR, "Privato", 9, 'U'),
("CAPODANNO 2014", "2014-01-01 19:30:50", "Pubblico", 11, 'U'),
("Le mie foto", CURRENT_DATE - INTERVAL 3 MONTH - INTERVAL 23 DAY - INTERVAL 33 MINUTE, "Pubblico", 19, 'U'),
("I miei gatti!!", CURRENT_DATE - INTERVAL 2 MONTH - INTERVAL 24 DAY - INTERVAL 43 MINUTE, "Pubblico", 12, 'U'),
("Ritiro Fiorentina 2014", "2014-08-17 11:33:33", "Pubblico", 14, 'U'),
("Io che sgamo i miei omonimi", CURRENT_DATE - INTERVAL 3 MONTH - INTERVAL 16 DAY - INTERVAL 34 MINUTE, "Privato", 1, 'U'),
("Oh la la, la Tour Eiffel!", CURRENT_DATE - INTERVAL 4 MONTH - INTERVAL 2 DAY - INTERVAL 31 MINUTE, "Pubblico", 2, 'U');




BEGIN;
INSERT INTO Occupazione VALUES 
(6, "Impiegato", CURRENT_DATE - INTERVAL 1 YEAR - INTERVAL 1 MONTH - INTERVAL 1 DAY, NULL, "Dipendenti srl"),
(7, "Facchino", CURRENT_DATE - INTERVAL 3 YEAR - INTERVAL 11 MONTH - INTERVAL 21 DAY, NULL, "Dipendenti srl"),
(9, "Assistente", CURRENT_DATE - INTERVAL 1 MONTH - INTERVAL 3 DAY, NULL, "Dipendenti srl"),
(12, "Segretaria", CURRENT_DATE - INTERVAL 2 YEAR - INTERVAL 1 DAY, NULL, "Dipendenti srl"),
(14, "Postina", CURRENT_DATE - INTERVAL 9 YEAR - INTERVAL 10 MONTH - INTERVAL 30 DAY, NULL, "Poste Italiane"),
(11, "Lavapiatti", CURRENT_DATE - INTERVAL 6 YEAR, CURRENT_DATE - INTERVAL 5 YEAR - INTERVAL 1 MONTH, "Ristorante Da Piero"),
(11, "Aiuto cuoco", CURRENT_DATE - INTERVAL 5 YEAR - INTERVAL 1 MONTH, CURRENT_DATE - INTERVAL 1 YEAR - INTERVAL 4 MONTH - INTERVAL 13 DAY, "Ristorante Da Piero"),
(11, "Cuoco", CURRENT_DATE - INTERVAL 1 YEAR - INTERVAL 4 MONTH - INTERVAL 12 DAY, CURRENT_DATE, "Ristorante Da Piero"),
(11, "Disoccupato", CURRENT_DATE, NULL, "n.d."),
(13, "Studente", CURRENT_DATE - INTERVAL 5 YEAR - INTERVAL 3 MONTH, NULL, "Università La Sapienza");
COMMIT;




BEGIN;
INSERT INTO Interesse VALUES
(1, "Sport", "Daje Maggicaaa"),
(2, "Viaggi", "Uh la la, la tour Eiffel!"),
(4, "Lavoro", NULL),
(6, "Sport", "Napoli per sempre."),
(6, "Informatica", NULL),
(7, "Sport", NULL),
(10, "Cinema", NULL),
(13, "Musica", "Ovviamente, Muse!"),
(14, "Sport", "Forza viola!"),
(16, "Scienze", NULL),
(17, "SqlInjection", NULL),
(19, "Fotografia", NULL);
COMMIT;




-- CREAZIONE EVENTI --




-- Evento che gestisce lo sblocco degli utenti con numero di segnalazioni pari o inferiore 2 --

DROP EVENT IF EXISTS SbloccoUtente;
DELIMITER &&
CREATE EVENT SbloccoUtente
ON SCHEDULE EVERY 1 DAY
STARTS '2014-1-1 00:00:00'
DO
BEGIN

	UPDATE Amicizia
	SET Visibilita = 'Pubblico'
	WHERE 	Visibilita = 'Bloccato' AND 
			NumSegnalazioni < 3 AND 
			CURRENT_DATE >= DataUltimaSegnalazione + INTERVAL 1 MONTH;

END &&
DELIMITER ;




-- Evento che si occupa di catalogare gli utenti in base alla loro attività nei gruppi per scopi pubblicitari --

DROP EVENT IF EXISTS CategorizzazioneUtenti;
DELIMITER &&
CREATE EVENT CategorizzazioneUtenti
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
	

	DECLARE C_Post INTEGER DEFAULT 10;
	DECLARE C_Commento INTEGER DEFAULT 2;
	DECLARE C_MiPiace INTEGER DEFAULT 1;
	DECLARE C_Gruppo INTEGER DEFAULT 30;
	DECLARE DataLimite TIMESTAMP DEFAULT (CURRENT_TIMESTAMP - INTERVAL 30 DAY);


	DROP TABLE IF EXISTS CatUtenza;
	CREATE TABLE CatUtenza
	(
		Utente INT UNSIGNED NOT NULL,
		Tema VARCHAR(15) NOT NULL,
		IndiceAttivita FLOAT UNSIGNED DEFAULT 0,
		IndiceGradimento FLOAT UNSIGNED DEFAULT 0,
		
		PRIMARY KEY (Utente, Tema)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    
    
    -- Vista che JOINA i Post ai Gruppi --

	CREATE OR REPLACE VIEW PostGruppo AS
	SELECT P.Mittente AS Utente, G.Tema, P.DataOra, G.ID AS Gruppo, P.ID AS Post
	FROM Post P INNER JOIN Gruppo G ON (P.Destinatario = G.ID)
	WHERE P.Tipo = 'G';



	-- Calcolo l'indice di attività e lo sovrascrivo ai dati "bianchi" --
	INSERT INTO CatUtenza (Utente, Tema, IndiceAttivita)
	SELECT Utente, Tema, SUM(Parziale) AS IndiceAttivita
	FROM (	(SELECT Utente, Tema, (C_Post * SUM(Punteggio)) AS Parziale
			FROM (	SELECT Utente, Tema, Gruppo, 1/(FLOOR(DATEDIFF(CURRENT_TIMESTAMP, DataOra) * 0.142857) + 1) AS Punteggio
					FROM PostGruppo
					WHERE DataOra > DataLimite) AS PunteggioPost
			GROUP BY Utente, Tema)
			UNION ALL
			(SELECT Utente, Tema, (C_Commento * SUM(Punteggio)) AS Parziale
			FROM (	SELECT Utente, Tema, Gruppo, 1/(FLOOR(DATEDIFF(CURRENT_TIMESTAMP, C.DataOra) * 0.142857) + 1) AS Punteggio
					FROM PostGruppo P INNER JOIN Commento C ON (C.Post = P.Post)
					WHERE C.DataOra > DataLimite) AS PunteggioCommento
			GROUP BY Utente, Tema)
			UNION ALL
			(SELECT Utente, Tema, (C_MiPiace * SUM(Punteggio)) AS Parziale
			FROM (	SELECT Utente, Tema, Gruppo, 1/(FLOOR(DATEDIFF(CURRENT_TIMESTAMP, M.DataOra) * 0.142857) + 1) AS Punteggio
					FROM PostGruppo P INNER JOIN MiPiace M ON (M.Post = P.Post)
					WHERE M.DataOra > DataLimite) AS PunteggioMiPiace
			GROUP BY Utente, Tema)) AS AggregazioneAttivita
	GROUP BY Utente, Tema

	ON DUPLICATE KEY UPDATE IndiceAttivita = VALUES(IndiceAttivita);


	-- Calcolo l'indice di gradimento assoluto e lo sovrascrivo ai dati "bianchi" nell'attributo IndiceGradimento --
	INSERT INTO CatUtenza (Utente, Tema, IndiceGradimento)
	SELECT Utente, Tema, SUM(Punteggio) AS Punteggio
	FROM (	(SELECT P.Utente, G.Tema, (C_Gruppo * COUNT(*)) AS Punteggio
			FROM PartecipazioneG P INNER JOIN Gruppo G ON (P.Gruppo = G.ID)
			GROUP BY Utente, Tema)
			UNION ALL
			(SELECT Utente, Tema, IndiceAttivita
			FROM CatUtenza
			WHERE IndiceAttivita != 0)) AS IndiceGradimentoPreIncremento
	GROUP BY Utente, Tema

	ON DUPLICATE KEY UPDATE IndiceGradimento = VALUES(IndiceGradimento);


	-- Aggiorno l'indice di gradimento assoluto incrementandolo di un certo valore per impedire la decadenza totale --
	UPDATE CatUtenza
	SET IndiceGradimento = IndiceGradimento * 1.1 + 1
	WHERE (Utente, Tema) IN (SELECT Utente, Tema FROM Interesse);
    
    
    
    -- A partire dall'indice di gradimento assoluto ricavo il totale per Utente e lo uso come base per calcolare la percentuale per ogni Tema di ciascun Utente --
    INSERT INTO CatUtenza (Utente, Tema, IndiceGradimento)
    SELECT C.Utente, C.Tema, (C.IndiceGradimento * 100 / Tot.Totale) AS IndiceGradimento
    FROM CatUtenza C NATURAL JOIN (	SELECT Utente, SUM(IndiceGradimento) AS Totale
									FROM CatUtenza
									GROUP BY Utente) AS Tot
    WHERE C.IndiceGradimento != 0 AND Tot.Totale != 09
    
    ON DUPLICATE KEY UPDATE IndiceGradimento = VALUES(IndiceGradimento);	

END &&
DELIMITER ;




-- Evento che si occupa di monitorare l'andamento dei temi nelle ultime due settimane --

DROP EVENT IF EXISTS TrendTemi;
DELIMITER &&
CREATE EVENT TrendTemi
ON SCHEDULE EVERY 7 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 2 SECOND
DO
BEGIN
	
    -- Una variabile che mantiene il conteggio totale degli utenti presenti nel Database --
    
	DECLARE TotaleUtenti INTEGER DEFAULT 0;
	SET TotaleUtenti = (SELECT COUNT(*)
						FROM Utente);
	
    
    -- Creazione della tabella Trend durante la prima esecuzione --
    
	CREATE TABLE IF NOT EXISTS Trend 
	(
		Tema VARCHAR(15) NOT NULL,
		UtentiInteressati INT NOT NULL DEFAULT 0,
		PercentualeUtentiInteressati FLOAT UNSIGNED NOT NULL DEFAULT 0,
		IndiceAttivita FLOAT NOT NULL DEFAULT 0,
		Var1Sett INT NOT NULL DEFAULT 0,
		Var2Sett INT NOT NULL DEFAULT 0,

		PRIMARY KEY (Tema)
	)ENGINE=InnoDB DEFAULT CHARSET=latin1;


	-- Al primo avvio inserisce tutti i temi nella tabella Trend con indici "bianchi", ad ogni altra esecuzione
	-- controlla che non ci siano nuovi temi da inserire nella tabella dei Trend
    
	INSERT INTO Trend 
	SELECT Nome, 0, 0, 0, 0, 0
	FROM Tema
	WHERE Nome NOT IN (	SELECT Tema
						FROM Trend);
	
    
	-- Numero di utenti interessati ad un determinato tema che presentano un indice di gradimento superiore a quello indicato --
    
	CREATE OR REPLACE VIEW NumeroUtentiInteressati AS
	SELECT Tema, COUNT(*) AS UtentiInteressati
	FROM CatUtenza
	WHERE IndiceGradimento > 20
	GROUP BY Tema;


	-- Restituisce per ogni tema l'indice di attività totale (somma di tutti gli indici di attività per quel tema) --
    
	CREATE OR REPLACE VIEW Attivita AS
	SELECT Tema, SUM(IndiceAttivita) AS IndiceAttivita
	FROM CatUtenza
	GROUP BY Tema;
	
    
    -- Una vista che riassume, per ciascun tema, l'indice di attività totale ed il numero attuale di utenti interessati --

	CREATE OR REPLACE VIEW IndiciAttuali AS
	SELECT Tema, IndiceAttivita, UtentiInteressati
	FROM NumeroUtentiInteressati NATURAL JOIN Attivita ;



	-- Aggiornamento della tabella trend diviso in due fasi onde evitare divisioni per zero durante il calcolo--

	-- FASE 1: si aggiornano le variazioni settimanali solo nelle tuple con indice di attivita non nullo,
    -- un altro rischio di divisione per zero è possibile quando T.Var1Sett è uguale a (-100) tuttavia
    -- questo inconveniente si presenta insieme ad un calo a zero dell'indice di attività e per questo
    -- attributo abbiamo già preso precauzioni nella clausola WHERE. Risolviamo due problemi con una sola condizione
    
	UPDATE Trend T INNER JOIN IndiciAttuali I ON (T.Tema = I.Tema)
	SET	T.Var2Sett = ROUND((I.IndiceAttivita / (T.IndiceAttivita * 100 / (T.Var1Sett + 100))) * 100 - 100),
		T.Var1Sett = ROUND((I.IndiceAttivita / T.IndiceAttivita) * 100 - 100)
	WHERE T.IndiceAttivita != 0;

	-- FASE 2: si aggiornano gli altri 3 indici senza alcun rischio di divisioni per zero
    
	UPDATE Trend T INNER JOIN IndiciAttuali I ON (T.Tema = I.Tema)
	SET	T.UtentiInteressati = I.UtentiInteressati,
		T.PercentualeUtentiInteressati = ((I.UtentiInteressati * 100) / TotaleUtenti),
		T.IndiceAttivita = I.IndiceAttivita;

END &&
DELIMITER ;