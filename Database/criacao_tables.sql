/* Query sql para a criação das tablelas no banco de dados, no nivel bronze do DW*/

-- CRIAÇÃO DAS TABELAS

-- Criação da tabela IBC-Br
IF OBJECT_ID ('bronze.ibc_br', 'U') IS NOT NULL
	DROP TABLE bronze.ibc_br;
CREATE TABLE bronze.ibc_br(
id_ibcbr INT NOT NULL PRIMARY KEY,
ano_e_mes NVARCHAR(6) NOT NULL,
ibc_br FLOAT NOT NULL,
);

-- Criação da tabela de informações do brasil
IF OBJECT_ID('bronze.infos_brasil', 'U') IS NOT NULL
	DROP TABLE bronze.infos_brasil;
CREATE TABLE bronze.infos_brasil(
id_infos_brasil INT NOT NULL PRIMARY KEY,
ano_infos_brasil INT NOT NULL,
DIVIDA_LIQUIDA_BRASIL FLOAT NOT NULL,
DIVIDA_BRUTA_BRASIL FLOAT NOT NULL, 
DESPESA_BRASIL FLOAT NOT NULL,
INFLACAO FLOAT NOT NULL,
);


-- Criação da tabela do PIB
IF OBJECT_ID('bronze.pib', 'U') IS NOT NULL
	DROP TABLE bronze.pib;
CREATE TABLE bronze.pib(
id_pib INT NOT NULL PRIMARY KEY,
PIB_VARIACAO FLOAT NOT NULL,
VALOR_PIB_REAIS INT NOT NULL,
VALOR_PIB_DOLAR INT NOT NULL,
TAXA_CAMBIO_PIB INT NOT NULL,
PIB_PER_CAPITA_REAL INT NOT NULL,
POPULACAO_ESTIMADA INT NOT NULL,
);

-- Criação da tabela de taxa de cambio
IF OBJECT_ID('bronze.taxa_cambio', 'U') IS NOT NULL
	DROP TABLE bronze.taxa_cambio;
CREATE TABLE bronze.taxa_cambio(
id_taxa_cambio INT NOT NULL PRIMARY KEY,
ano_mes_dia DATE NOT NULL,
codigo VARCHAR(15) NOT NULL,
raw_date VARCHAR(25) NOT NULL,
dia_taxa_cambio INT NOT NULL,
mes_taxa_cambio INT NOT NULL,
ano_taxa_cambio INT NOT NULL,
valor_taxa_cambio FLOAT NOT NULL
);

-- Criação tabela de dados do brasil
IF OBJECT_ID('bronze.dados_brasil', 'U') IS NOT NULL
	DROP TABLE bronze.dados_brasil;
CREATE TABLE bronze.dados_brasil(
id_dados_brasil INT NOT NULL PRIMARY KEY,
nome_pais VARCHAR(6) NOT NULL,
pais_codigo VARCHAR(3) NOT NULL,
tipo_informacao VARCHAR(100) NOT NULL,
codigo_de_serie VARCHAR(20) NOT NULL,
ano_2015 FLOAT NOT NULL,
ano_2016 FLOAT NOT NULL,
ano_2017 FLOAT NOT NULL,
ano_2018 FLOAT NOT NULL,
ano_2019 FLOAT NOT NULL,
ano_2020 FLOAT NOT NULL,
ano_2021 FLOAT NOT NULL,
ano_2022 FLOAT NOT NULL,
ano_2023 FLOAT NOT NULL,
ano_2024 FLOAT NOT NULL,
);

