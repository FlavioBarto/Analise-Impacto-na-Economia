-- Criação da tabela silver.ibc_br
IF OBJECT_ID('silver.ibc_br', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.ibc_br;
END
CREATE TABLE silver.ibc_br (
	ibc_brID INT NOT NULL,
	ano_ibcbr INT NOT NULL,
	mes_ibcbr INT NOT NULL,
	ibc_br DECIMAL(10,6) NOT NULL
);


-- Criação da tabela silver.infos_brasil
IF OBJECT_ID('silver.dados_brasil', 'U') IS NOT NULL
    DROP TABLE silver.dados_brasil
CREATE TABLE silver.dados_brasil(
    dados_brasilID int identity(1,1) primary key not null,
    codigo_pais nvarchar(20) not null,
    tipo_informacao nvarchar(100) not null,
    codigo_de_serie nvarchar(100) not null,
    ano_2017 decimal(30,20) not null,
    ano_2018 decimal(30,20) not null,
    ano_2019 decimal(30,20) not null,
    ano_2020 decimal(30,20) not null,
    ano_2021 decimal(30,20) not null,
    ano_2022 decimal(30,20) not null,
    ano_2023 decimal(30,20) not null,
    ano_2024 decimal(30,20) not null,
    nome_pais nvarchar(20) not null);
-- Criação da tabela silver.pib
IF OBJECT_ID('silver.pib', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.pib;
END
CREATE TABLE silver.pib (
	pibID INT PRIMARY KEY,
	ANO_PIB INT NOT NULL,
	PIB_VARIACAO DECIMAL(18,6) NOT NULL,
	VALOR_PIB_REAIS NVARCHAR(20) NOT NULL,
	VALOR_PIB_DOLAR NVARCHAR(20) NOT NULL,
	TAXA_CAMBIO_PIB NVARCHAR(20) NOT NULL,
	PIB_PER_CAPITA_REAL NVARCHAR(20) NOT NULL,
	POPULACAO_ESTIMADA NVARCHAR(20) NOT NULL,
);

INSERT INTO silver.pib (pibID, ANO_PIB, 
PIB_VARIACAO, VALOR_PIB_REAIS, 
VALOR_PIB_DOLAR, TAXA_CAMBIO_PIB, 
PIB_PER_CAPITA_REAL, POPULACAO_ESTIMADA)
SELECT pibID, ANO_PIB, PIB_VARIACAO,VALOR_PIB_REAIS, VALOR_PIB_DOLAR, TAXA_CAMBIO_PIB, PIB_PER_CAPITA_REAL, POPULACAO_ESTIMADA
FROM bronze.pib

-- Criação da tabela silver.taxa_cambio
IF OBJECT_ID('silver.taxa_cambio', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.taxa_cambio;
END
CREATE TABLE silver.taxa_cambio (
	taxa_cambioID INT PRIMARY KEY,
	codigo VARCHAR(15) NOT NULL,
	dia_taxa_cambio INT NOT NULL,
	mes_taxa_cambio INT NOT NULL,
	ano_taxa_cambio INT NOT NULL,
	valor_taxa_cambio DECIMAL(18,6) NOT NULL,
);

-- Criação da tabela silver.dados_brasil
IF OBJECT_ID('silver.dados_brasil', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.dados_brasil;
END
CREATE TABLE silver.dados_brasil (
	dados_brasilID INT IDENTITY(1,1) PRIMARY KEY,
	nome_pais VARCHAR(6) NOT NULL,
	pais_codigo VARCHAR(3) NOT NULL,
	tipo_informacao VARCHAR(100) NOT NULL,
	codigo_de_serie VARCHAR(200) NOT NULL,
	ano_2015 VARCHAR(200) NOT NULL,
	ano_2017 VARCHAR(200) NOT NULL,
	ano_2018 VARCHAR(200) NOT NULL,
	ano_2019 VARCHAR(200) NOT NULL,
	ano_2020 VARCHAR(200) NOT NULL,
	ano_2021 VARCHAR(200) NOT NULL,
	ano_2022 VARCHAR(200) NOT NULL,
	ano_2023 VARCHAR(200) NOT NULL,
	ano_2024 VARCHAR(200) NOT NULL,
);

-- Criação da tabela silver.inpc
IF OBJECT_ID('silver.inpc', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.inpc;
END
CREATE TABLE silver.inpc (
	inpcID INT PRIMARY KEY,
	ano_inpc INT NOT NULL,
	JAN DECIMAL(3,2) NOT NULL,
	FEV DECIMAL(3,2) NOT NULL,
	MAR DECIMAL(3,2) NOT NULL,
	ABR DECIMAL(3,2) NOT NULL,
	MAI DECIMAL(3,2) NOT NULL,
	JUN DECIMAL(3,2) NOT NULL,
	JUL DECIMAL(3,2) NOT NULL,
	AGO DECIMAL(3,2) NOT NULL,
	SETE DECIMAL(3,2) NOT NULL,
	OUTU DECIMAL(3,2) NOT NULL,
	NOV DECIMAL(3,2) NOT NULL,
	DEZ DECIMAL(3,2) NOT NULL,
	ACUMULADO_NO_ANO DECIMAL(5,2) NOT NULL,
);

-- Criação da tabela silver.world_data
IF OBJECT_ID('silver.world_data', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.world_data;
END
CREATE TABLE silver.world_data (
	wdID INT IDENTITY(1,1) PRIMARY KEY,
	country_name VARCHAR(50) NOT NULL,
	country_id VARCHAR(3) NOT NULL,
	year_wd INT NOT NULL,
	inflation_cpi DECIMAL(30,20),
	gdp_wd DECIMAL(38,20),
	gdp_percapita DECIMAL(38,20),
	unemployment_rate DECIMAL(38,20),
	interest_rate DECIMAL(38,20),
	inflation_gdp DECIMAL(38,20),
	GDP_growth DECIMAL(38,20),
	current_account_balance DECIMAL(38,20),
	government_expense DECIMAL(38,20),
	government_revenue VARCHAR(30),
	tax_revenue VARCHAR(30),
	gross_national_income DECIMAL(38,20),
	public_debt DECIMAL(38,20),
);


--Criando tabela silver.taxa_desemprego
IF OBJECT_ID('silver.taxa_desemprego', 'U') IS NOT NULL
    DROP TABLE silver.taxa_desemprego
CREATE TABLE silver.taxa_desemprego(
    taxa_desempregoID int primary key not null,
    ano_id int not null,
    taxa_desemprego decimal(5,2) not null);

--Criando tabela silver.mes
IF OBJECT_ID('silver.mes', 'U') IS NOT NULL
	DROP TABLE silver.mes
CREATE TABLE silver.mes(
	mes_id int identity(1,1) primary key not null,
	mes int not null,
	nome nvarchar(20) not null);