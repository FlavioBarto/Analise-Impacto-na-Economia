CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	-- Inserindo dados nas tabelas silver
	-- Inserindo dados na tabela ibc_br
	TRUNCATE TABLE silver.ibc_br; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT silver.ibc_br
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\IBC-Br.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		TABLOCK
	);
	
	-- Inserindo dados na taxa de cambio
	TRUNCATE TABLE silver.taxa_cambio -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT silver.taxa_cambio
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\Taxa_Cambio.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		TABLOCK
	);
	

	-- Inserindo dados na tabela PIB
	TRUNCATE TABLE silver.pib; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT silver.pib
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\PIB.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001' ,
		TABLOCK
	);

	-- Inserindo dados na tabela Infos Brasil
	TRUNCATE TABLE silver.infos_brasil; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT silver.infos_brasil
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\Infos_Brasil.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		TABLOCK
	);

	-- Insert de dados na tabela dados_brasil, do arquivo variados.csv
	TRUNCATE TABLE silver.dados_brasil; -- Remove todas as linhas da tabela antes de adicionar as linhas
	BULK INSERT silver.dados_brasil
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\variados.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a', 
		TABLOCK,
		CODEPAGE = '65001' 
	);
	-- SELECT * FROM silver.dados_brasil
	
	TRUNCATE TABLE silver.inpc
	BULK INSERT silver.inpc
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\INPC_2004_2024.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK,
		CODEPAGE = '65001'
	);

	TRUNCATE TABLE silver.world_data
	BULK INSERT silver.world_data
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\world_bank_data_2025.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK,
		CODEPAGE = '65001'
	);

	TRUNCATE TABLE silver.taxa_desemprego
	BULK INSERT silver.taxa_desemprego
	FROM 'C:\Users\leona\Analise-Impacto-na-Economia-1\Data\Taxa_desemprego.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK,
		CODEPAGE = '65001'
		);

	ALTER TABLE silver.taxa_cambio
	DROP COLUMN raw_date, ano_mes_dia;

	-- Adicionando chaves estrangeiras
	ALTER TABLE silver.world_data
	ADD wdID INT IDENTITY(1,1) PRIMARY KEY NOT NULL

	ALTER TABLE silver.ibc_br
	ADD 
	anoID INT,
	mesID INT,
	CONSTRAINT FK_ibc_br_ano FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_ibc_br_mes FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)

	ALTER TABLE silver.infos_brasil
	ADD	
	anoID INT,
	mesID INT,
	CONSTRAINT FK_infos_brasil_anoID FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_infos_brasil_mesID FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)

	ALTER TABLE silver.pib
	ADD
	anoID INT,
	mesID INT,
	CONSTRAINT FK_pib_anoID FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_pib_mesID FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)

	ALTER TABLE silver.taxa_cambio
	ADD
	anoID INT,
	mesID INT,
	CONSTRAINT FK_taxa_cambio_anoID FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_taxa_cambio_mesID FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)

	ALTER TABLE silver.dados_brasil
	ADD
	anoID INT,
	mesID INT,
	CONSTRAINT FK_dados_brasil_anoID FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_dados_brasil_mesID FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)

	ALTER TABLE silver.inpc
	ADD
	anoID INT,
	mesID INT,
	CONSTRAINT FK_inpc_anoID FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_inpc_mesID FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)

	ALTER TABLE silver.taxa_desemprego
	ADD
	anoID INT,
	mesID INT,
	CONSTRAINT FK_taxa_desemprego_anoID FOREIGN KEY (anoID) REFERENCES silver.ano(anoID),
	CONSTRAINT FK_taxa_desemprego_mesID FOREIGN KEY (mesID) REFERENCES silver.mes(mesID)
END;
