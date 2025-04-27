-- DROP DATABASE aerodata;
CREATE DATABASE aerodata;
USE aerodata;

CREATE TABLE Companhia_Aerea (
    cnpj CHAR(14) PRIMARY KEY,
    razao_social VARCHAR(45),
    nome_fantasia VARCHAR(45),
    sigla_companhia CHAR(3) UNIQUE,
    representante_legal VARCHAR(45)
);

-- Tabela Usuario com senha como SHA-256 (64 caracteres)
CREATE TABLE Usuario (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100),
    cargo VARCHAR(45),
    CONSTRAINT chk_cargo
        CHECK (cargo IN ('Gestor de Malha Aérea', 'Diretor de Companhia Aérea')),
    email VARCHAR(50) UNIQUE,
    senha CHAR(64), -- Armazena hash SHA-256
    fk_companhia CHAR(14),
    CONSTRAINT fk_companhiaUsuario
		FOREIGN KEY (fk_companhia) 
			REFERENCES Companhia_Aerea(cnpj)
);


CREATE TABLE Voos (
	id_Voo INT PRIMARY KEY AUTO_INCREMENT,
	numero_voo VARCHAR (10),
	dia_referencia DATE,
	aeroporto_partida VARCHAR (255),
	sigla_aeroporto_partida CHAR (3),
	aeroporto_destino VARCHAR (255),
	sigla_aeroporto_destino CHAR (3),
	situacao_voo VARCHAR (45),
	situacao_partida VARCHAR (45),
	situacao_chegada VARCHAR (45),
	fk_companhia CHAR (14),
    CONSTRAINT fk_companhiaVoos
		FOREIGN KEY (fk_companhia) 
			REFERENCES Companhia_Aerea(cnpj)
);

CREATE TABLE Alertas (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    data_hora DATETIME,
    tipo VARCHAR(30),
    CONSTRAINT chk_tipo
		CHECK (tipo IN ('Voo cancelado', 'Voo atrasado')),
    mensagem VARCHAR(100),
    fk_voo INT,
    CONSTRAINT fk_AlertasVoos
		FOREIGN KEY (fk_voo) 
			REFERENCES Voos(id_voo)
);

-- TRIGGER para hashear senha no INSERT
DELIMITER //

CREATE TRIGGER trg_hash_senha_insert
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    SET NEW.senha = SHA2(NEW.senha, 256);
END;
//

DELIMITER ;

-- TRIGGER para hashear senha no UPDATE
DELIMITER //

CREATE TRIGGER trg_hash_senha_update
BEFORE UPDATE ON Usuario
FOR EACH ROW
BEGIN
    SET NEW.senha = SHA2(NEW.senha, 256);
END;
//

DELIMITER ;


SHOW TABLES;

SELECT * FROM Voos;

 -- CREATE TABLE IF NOT EXISTS Voos (
                           -- id IDENTITY PRIMARY KEY,
                            -- numero_voo VARCHAR(20),
                            -- dia_referencia DATE,
                            -- situacao_voo VARCHAR(50),
                            -- situacao_partida VARCHAR(50),
                            -- situacao_chegada VARCHAR(50),
                            -- fk_rota INT,
                            -- fk_companhia INT)
