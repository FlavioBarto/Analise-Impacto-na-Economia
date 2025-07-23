/*
========================================
Cria o Banco de dados e os Schemas
========================================

Esse Script cria um novo banco de dados chamado 'economyBrazil' depois de checar se ja existe. Se ele existe, vai ser deletado(DROP) e recriado
o script também cria 3 Schemas com o banco de dados: 'bronze', 'silver', 'gold'

AVISO: Rodar o script ira deletar todo o banco de dados 'economyBrazil' se ele ja existir. Todos os dados serão deletados
*/


IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'economyBrazil')
BEGIN
	ALTER DATABASE economyBrazil SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE economyBrazil;
END;
GO

-- Create the 'economyBrazil' database
CREATE DATABASE economyBrazil;
GO

USE economyBrazil;
GO

--CREATE Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
