-- SET o valor para inserir valores de identidade como ON nas tabelas
SET IDENTITY_INSERT economyBrazil.silver.infos_brasil ON

-- Inserção de dados no schema silver

-- Inserção na tabela ibc_br
TRUNCATE TABLE silver.ibc_br
INSERT INTO silver.ibc_br (ibc_brID, ano_ibcbr, mes_ibcbr, ibc_br) 
SELECT ibc_brID, ano, mes, ibc_br
FROM bronze.ibc_br
-- SELECT * FROM silver.ibc_br

-- Inserção na tabela infos_brasil
TRUNCATE TABLE silver.infos_brasil
INSERT INTO silver.infos_brasil 
(infos_brasilID, ano_infos_brasil, 
DIVIDA_LIQUIDA_BRASIL, DIVIDA_BRUTA_BRASIL, 
DESPESA_BRASIL, INFLACAO)
SELECT infos_brasilID, ano_infos_brasil, DIVIDA_LIQUIDA_BRASIL, DIVIDA_BRUTA_BRASIL, DESPESA_BRASIL, INFLACAO
FROM bronze.infos_brasil
-- SELECT * FROM silver.infos_brasil

-- Inserção na tabela PIB
TRUNCATE TABLE silver.pib
INSERT INTO silver.pib (pibID, ANO_PIB, 
PIB_VARIACAO, VALOR_PIB_REAIS, 
VALOR_PIB_DOLAR, TAXA_CAMBIO_PIB, 
PIB_PER_CAPITA_REAL, POPULACAO_ESTIMADA)
SELECT pibID, ANO_PIB, PIB_VARIACAO,VALOR_PIB_REAIS, VALOR_PIB_DOLAR, TAXA_CAMBIO_PIB, PIB_PER_CAPITA_REAL, POPULACAO_ESTIMADA
FROM bronze.pib
-- SELECT * FROM silver.pib

-- Inserção na tabela taxa_cambio
TRUNCATE TABLE silver.taxa_cambio
INSERT INTO silver.taxa_cambio(taxa_cambioID, codigo, dia_taxa_cambio, mes_taxa_cambio, ano_taxa_cambio, valor_taxa_cambio)
SELECT taxa_cambioID, codigo, dia_taxa_cambio, mes_taxa_cambio, ano_taxa_cambio, valor_taxa_cambio
FROM bronze.taxa_cambio
-- SELECT * FROM silver.taxa_cambio

-- Inserção na tabela inpc
TRUNCATE TABLE silver.inpc
INSERT INTO silver.inpc (inpcID, ano_inpc, JAN, FEV, MAR, ABR, MAI, JUN, JUL, AGO, SETE, OUTU, NOV, DEZ, ACUMULADO_NO_ANO)
SELECT inpcID, ano_inpc, JAN, FEV, MAR, ABR, MAI, JUN, JUL, AGO, SETE, OUTU, NOV, DEZ, ACUMULADO_NO_ANO
FROM bronze.inpc
-- SELECT * FROM silver.inpc

-- Inserção na tabela world_data
INSERT INTO silver.world_data (
country_name, country_id, year_wd, inflation_cpi, 
gdp_wd, gdp_percapita, unemployment_rate, interest_rate, inflation_gdp, GDP_growth, 
current_account_balance, government_expense, government_revenue, tax_revenue, gross_national_income, public_debt)
SELECT country_name, country_id, year_wd, inflation_cpi, gdp_wd, gdp_percapita, unemployment_rate, interest_rate, inflation_gdp, GDP_growth, current_account_balance, government_expense, government_revenue, tax_revenue, gross_national_income, public_debt
FROM bronze.world_data
-- SELECT * FROM silver.world_data
