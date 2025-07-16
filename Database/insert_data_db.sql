CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	-- Inserindo dados nas tabelas bronze
	-- Inserindo dados na tabela ibc_br
	TRUNCATE TABLE bronze.ibc_br; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT bronze.ibc_br
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\IBC-Br.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		TABLOCK
	);
	
	-- Inserindo dados na taxa de cambio
	TRUNCATE TABLE bronze.taxa_cambio -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT bronze.taxa_cambio
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\Taxa_Cambio.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		TABLOCK
	);
	

	-- Inserindo dados na tabela PIB
	TRUNCATE TABLE bronze.pib; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT bronze.pib
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\PIB.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001' ,
		TABLOCK
	);

	-- Inserindo dados na tabela Infos Brasil
	TRUNCATE TABLE bronze.infos_brasil; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT bronze.infos_brasil
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\Infos_Brasil.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		TABLOCK
	);

	-- Insert de dados na tabela dados_brasil, do arquivo variados.csv
	TRUNCATE TABLE bronze.dados_brasil; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT bronze.dados_brasil
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\variados.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a', 
		TABLOCK,
		CODEPAGE = '65001' 
	);
	-- SELECT * FROM bronze.dados_brasil
	
	TRUNCATE TABLE bronze.inpc
	BULK INSERT bronze.inpc
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\INPC_2004_2024.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK,
		CODEPAGE = '65001'
	);

	TRUNCATE TABLE bronze.world_data
	BULK INSERT bronze.world_data
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\world_bank_data_2025.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK,
		CODEPAGE = '65001'
	);
	ALTER TABLE bronze.taxa_cambio
	DROP COLUMN raw_date, ano_mes_dia;

	ALTER TABLE bronze.world_data
	ADD wdID INT IDENTITY(1,1) PRIMARY KEY NOT NULL
END;
