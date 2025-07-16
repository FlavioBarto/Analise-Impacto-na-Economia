select * from silver.ano;

select * from silver.ano;
INSERT INTO silver.ano (ano)
SELECT taxa_desemprego_ano FROM bronze.taxa_desemprego;


--Criando tabela silver.mes
IF OBJECT_ID('silver.mes', 'U') IS NOT NULL
	DROP TABLE silver.mes
CREATE TABLE silver.mes(
	mes_id int identity(1,1) primary key not null,
	mes int not null,
	nome nvarchar(20) not null);


--Inserindo dados na tabela silver.mes
INSERT INTO silver.mes(mes, nome)
SELECT DISTINCT 
    mes_taxa_cambio,
    CASE 
        WHEN mes_taxa_cambio = 1 THEN 'Janeiro'
        WHEN mes_taxa_cambio = 2 THEN 'Fevereiro'
        WHEN mes_taxa_cambio = 3 THEN 'Março'
        WHEN mes_taxa_cambio = 4 THEN 'Abril'
        WHEN mes_taxa_cambio = 5 THEN 'Maio'
        WHEN mes_taxa_cambio = 6 THEN 'Junho'
        WHEN mes_taxa_cambio = 7 THEN 'Julho'
        WHEN mes_taxa_cambio = 8 THEN 'Agosto'
        WHEN mes_taxa_cambio = 9 THEN 'Setembro'
        WHEN mes_taxa_cambio = 10 THEN 'Outubro'
        WHEN mes_taxa_cambio = 11 THEN 'Novembro'
        WHEN mes_taxa_cambio = 12 THEN 'Dezembro'
        ELSE 'Mês Inválido'
    END AS nome_mes
FROM bronze.taxa_cambio;




--Criando tabela silver.dados_brasil
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

--Inserindo dados na silver.dados_brasil
INSERT INTO silver.dados_brasil (codigo_pais, tipo_informacao, codigo_de_serie, ano_2017, ano_2018, ano_2019, ano_2020, ano_2021, ano_2022, ano_2023, ano_2024, nome_pais)
SELECT
    pais_codigo,
    tipo_informacao,
    codigo_de_serie,
    -- Usando TRY_CAST para tentar converter para DECIMAL.
    -- Se a conversão falhar (retornar NULL), ISNULL substitui o NULL por 0.
    ISNULL(TRY_CAST(ano_2017 AS DECIMAL(30,20)), 0) AS ano_2017,
    ISNULL(TRY_CAST(ano_2018 AS DECIMAL(30,20)), 0) AS ano_2018,
    ISNULL(TRY_CAST(ano_2019 AS DECIMAL(30,20)), 0) AS ano_2019,
    ISNULL(TRY_CAST(ano_2020 AS DECIMAL(30,20)), 0) AS ano_2020,
    ISNULL(TRY_CAST(ano_2021 AS DECIMAL(30,20)), 0) AS ano_2021,
    ISNULL(TRY_CAST(ano_2022 AS DECIMAL(30,20)), 0) AS ano_2022,
    ISNULL(TRY_CAST(ano_2023 AS DECIMAL(30,20)), 0) AS ano_2023,
    ISNULL(TRY_CAST(ano_2024 AS DECIMAL(30,20)), 0) AS ano_2024,
    CASE
        WHEN nome_pais = 'Brazil' THEN 'Brasil'
        ELSE nome_pais -- Adicionado para lidar com outros nomes de país, se houver
    END AS nome_pais
FROM bronze.dados_brasil;

select * from bronze.infos_brasil;
select * from silver.ano;

--Criando tabela silver.taxa_desemprego
IF OBJECT_ID('silver.taxa_desemprego', 'U') IS NOT NULL
    DROP TABLE silver.taxa_desemprego
CREATE TABLE silver.taxa_desemprego(
    taxa_desempregoID int primary key not null,
    ano_id int not null,
    taxa_desemprego decimal(5,2) not null);

--Inserindo dados na silver.taxa_desemprego
INSERT INTO silver.taxa_desemprego (taxa_desempregoID, ano_id, taxa_desemprego)
SELECT btd.taxa_desempregoID, s.ano_id, btd.taxa_desemprego from bronze.taxa_desemprego btd
JOIN silver.ano s ON s.ano = btd.taxa_desemprego_ano
WHERE s.ano = btd.taxa_desemprego_ano;

--Adicionando FK
ALTER TABLE silver.taxa_desemprego
ADD CONSTRAINT FK_taxa_desemprego_ano_id FOREIGN KEY(ano_id) REFERENCES silver.ano(ano_id)

--Criando tabela silver.ibc_br
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

-- Inserção na tabela ibc_br
TRUNCATE TABLE silver.ibc_br
INSERT INTO silver.ibc_br (ibc_brID, ano_ibcbr, mes_ibcbr, ibc_br) 
SELECT bi.ibc_brID, sa.ano_id, sm.mes_id, bi.ibc_br from bronze.ibc_br bi
JOIN silver.ano sa ON bi.ano = sa.ano
JOIN silver.mes sm ON bi.mes = sm.mes
WHERE sa.ano < 2025;


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

select * from silver.mes;
-- Inserção na tabela taxa_cambio
TRUNCATE TABLE silver.taxa_cambio
INSERT INTO silver.taxa_cambio(taxa_cambioID, codigo, dia_taxa_cambio, mes_taxa_cambio, ano_taxa_cambio, valor_taxa_cambio)
SELECT btc.taxa_cambioID, btc.codigo, btc.dia_taxa_cambio, sm.mes_id, sa.ano_id, btc.valor_taxa_cambio from bronze.taxa_cambio btc
JOIN silver.ano sa ON btc.ano_taxa_cambio = sa.ano
JOIN silver.mes sm ON btc.mes_taxa_cambio = sm.mes
WHERE sa.ano < 2025;

select * from silver.taxa_cambio;


-------Infos_brasil - world data
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


-- Inserção na tabela world_data
INSERT INTO silver.world_data (
country_name, country_id, year_wd, inflation_cpi, 
gdp_wd, gdp_percapita, unemployment_rate, interest_rate, inflation_gdp, GDP_growth, 
current_account_balance, government_expense, government_revenue, tax_revenue, gross_national_income, public_debt)
SELECT bwd.country_name, bwd.country_id, sa.ano_id, bwd.inflation_cpi, ISNULL(bwd.gdp_wd,0) as gdp_wd, ISNULL(bwd.gdp_percapita, 0) as gdp_percapita, ISNULL(bwd.unemployment_rate, 0) as unemployment_rate, ISNULL(bwd.interest_rate,0) as interest_rate, ISNULL(bwd.inflation_gdp, 0) as inflation_gdp, ISNULL(bwd.GDP_growth, 0) as GDP_growth, ISNULL(bwd.current_account_balance, 0) as current_account_balance, ISNULL(bwd.government_expense,0) as government_expense, ISNULL(bwd.government_revenue, 0) as government_revenue, ISNULL(bwd.tax_revenue, 0) as tax_revenue, ISNULL(bwd.gross_national_income,0) as gross_national_income, ISNULL(bwd.public_debt, 0) as public_debt
FROM bronze.world_data bwd
JOIN silver.ano sa ON bwd.year_wd = sa.ano
WHERE country_name IN ( 'United States',
        'China',
        'Japan',
        'Canada',
        'Brazil',
        'France',
        'Germany',
        'United Kingdom',
        'Italy',
        'India');


-- Criação da tabela silver.infos_brasil
IF OBJECT_ID('silver.infos_brasil', 'U') IS NOT NULL
BEGIN
	DROP TABLE silver.infos_brasil;
END
CREATE TABLE silver.infos_brasil (
	infos_brasilID INT NOT NULL,
	ano_infos_brasil INT NOT NULL,
	DIVIDA_LIQUIDA_BRASIL DECIMAL(10,3) NOT NULL,
	DIVIDA_BRUTA_BRASIL DECIMAL(10,3) NOT NULL,
	DESPESA_BRASIL DECIMAL(10,3) NOT NULL,
	INFLACAO DECIMAL(10,2) NOT NULL,
);

-- Inserção na tabela infos_brasil
TRUNCATE TABLE silver.infos_brasil
INSERT INTO silver.infos_brasil 
(infos_brasilID, ano_infos_brasil, 
DIVIDA_LIQUIDA_BRASIL, DIVIDA_BRUTA_BRASIL, 
DESPESA_BRASIL, INFLACAO)
SELECT bib.infos_brasilID, sa.ano_id, bib.DIVIDA_LIQUIDA_BRASIL, bib.DIVIDA_BRUTA_BRASIL, bib.DESPESA_BRASIL, bib.INFLACAO
FROM bronze.infos_brasil bib
JOIN silver.ano sa ON bib.ano_infos_brasil = sa.ano;


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


-- Inserção na tabela inpc
TRUNCATE TABLE silver.inpc
INSERT INTO silver.inpc (inpcID, ano_inpc, JAN, FEV, MAR, ABR, MAI, JUN, JUL, AGO, SETE, OUTU, NOV, DEZ, ACUMULADO_NO_ANO)
SELECT bi.inpcID, sa.ano_id, bi.JAN, bi.FEV, bi.MAR, bi.ABR, bi.MAI, bi.JUN, bi.JUL, bi.AGO, bi.SETE, bi.OUTU, bi.NOV, bi.DEZ, bi.ACUMULADO_NO_ANO
FROM bronze.inpc bi
JOIN silver.ano sa ON bi.ano_inpc = sa.ano;

select * from silver.ano;

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

IF OBJECT_ID('silver.ano', 'U') IS NOT NULL
	DROP TABLE silver.ano
CREATE TABLE silver.ano(
	ano_id int primary key not null,
	ano int not null);



-- Inserção na tabela PIB
TRUNCATE TABLE silver.pib
INSERT INTO silver.pib (pibID, ANO_PIB, 
PIB_VARIACAO, VALOR_PIB_REAIS, 
VALOR_PIB_DOLAR, TAXA_CAMBIO_PIB, 
PIB_PER_CAPITA_REAL, POPULACAO_ESTIMADA)
SELECT bp.pibID, sa.ano_id, bp.PIB_VARIACAO, bp.VALOR_PIB_REAIS, bp.VALOR_PIB_DOLAR, bp.TAXA_CAMBIO_PIB, bp.PIB_PER_CAPITA_REAL, bp.POPULACAO_ESTIMADA
FROM bronze.pib bp
JOIN silver.ano sa ON sa.ano = bp.ANO_PIB;

select * from bronze.pib;


