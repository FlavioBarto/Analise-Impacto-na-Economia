/* Query SQL para a criação das tabelas no banco de dados, no nível bronze do DW */

-- CRIAÇÃO DAS TABELAS

-- Criação da tabela IBC-Br
IF OBJECT_ID ('bronze.ibc_br', 'U') IS NOT NULL
	DROP TABLE bronze.ibc_br;
CREATE TABLE bronze.ibc_br (
	ibc_brID INT IDENTITY(1,1) PRIMARY KEY,
	ano INT NOT NULL,
	mes INT NOT NULL,
	ibc_br DECIMAL(10,6) NOT NULL
);

-- Criação da tabela de informações do Brasil
IF OBJECT_ID('bronze.infos_brasil', 'U') IS NOT NULL
	DROP TABLE bronze.infos_brasil;
CREATE TABLE bronze.infos_brasil (
	infos_brasilID INT IDENTITY(1,1) PRIMARY KEY,
	ano_infos_brasil INT NOT NULL,
	DIVIDA_LIQUIDA_BRASIL DECIMAL(10,3) NOT NULL,
	DIVIDA_BRUTA_BRASIL DECIMAL(10,3) NOT NULL,
	DESPESA_BRASIL DECIMAL(10,3) NOT NULL,
	INFLACAO DECIMAL(10,2) NOT NULL
);

-- Criação da tabela do PIB
IF OBJECT_ID('bronze.pib', 'U') IS NOT NULL
	DROP TABLE bronze.pib;
CREATE TABLE bronze.pib (
	pibID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ANO_PIB INT NOT NULL,
	PIB_VARIACAO DECIMAL(18,6) NOT NULL,
	VALOR_PIB_REAIS NVARCHAR(20) NOT NULL,
	VALOR_PIB_DOLAR NVARCHAR(20) NOT NULL,
	TAXA_CAMBIO_PIB NVARCHAR(20) NOT NULL,
	PIB_PER_CAPITA_REAL NVARCHAR(20) NOT NULL,
	POPULACAO_ESTIMADA NVARCHAR(20) NOT NULL
);

-- Criação da tabela de taxa de câmbio
IF OBJECT_ID('bronze.taxa_cambio', 'U') IS NOT NULL
	DROP TABLE bronze.taxa_cambio;
CREATE TABLE bronze.taxa_cambio (
	taxa_cambioID INT IDENTITY(1,1) PRIMARY KEY,
	ano_mes_dia DATE NOT NULL,
	codigo VARCHAR(15) NOT NULL,
	raw_date VARCHAR(25) NOT NULL,
	dia_taxa_cambio INT NOT NULL,
	mes_taxa_cambio INT NOT NULL,
	ano_taxa_cambio INT NOT NULL,
	valor_taxa_cambio DECIMAL(18,6) NOT NULL
);

-- Criação da tabela de dados do Brasil
IF OBJECT_ID('bronze.dados_brasil', 'U') IS NOT NULL
	DROP TABLE bronze.dados_brasil;
CREATE TABLE bronze.dados_brasil (
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
	ano_2024 VARCHAR(200) NOT NULL
);


-- Criação da tabela INPC
IF OBJECT_ID('bronze.inpc', 'U') IS NOT NULL
	DROP TABLE bronze.inpc
CREATE TABLE bronze.inpc(
	inpcID INT IDENTITY(1,1) PRIMARY KEY,
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
	ACUMULADO_NO_ANO DECIMAL (5,2) NOT NULL
);

-- Criação da tabela do world data (para possivel comparação com outros paises)

IF OBJECT_ID('bronze.world_data', 'U') IS NOT NULL
	DROP TABLE bronze.world_data
CREATE TABLE bronze.world_data(
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
	public_debt DECIMAL(38,20)
);

