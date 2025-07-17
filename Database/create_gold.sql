/* 
 ===============================
      CRIANDO CAMADA GOLD
 ===============================

 OBJETIVO:
    - Criar as tabelas dimensões e fatos da camada gold, facilitando as análises
        -> VIEWS: 
           * gold.fact_fatores_economicos_brasil - Esta view contém fatores macroeconômicos brasileiros.
            Sendo eles: variação do PIB, valor do PIB em reais, valor do PIB em dólares, taxa de câmbio, PIB per capita, população brasileira,
            dívida líquida, dívida bruta, despesas do Brasil, inflação, taxa de desemprego, inflação CPI, taxa de juros, inflação PIB,
            crescimento do PIB, balança de pagamentos, despesas do governo, receita do governo, receita tributária e renda nacional bruta.

            * gold.fact_fatores_economicos_internacionais - Esta view contém fatores macroeconômicos internacionais.
            Sendo eles: nome do país, código do país, ano, inflação CPI, PIB, PIB percapita, taxa de desemprego, taxa de juros, inflação PIB,
            balança de pagamentos, dispesas do governo, receita do governo

            * gold.dim_tempo - Esta view nos da controle de todos os anos e meses contidos no csv. Ou seja, ele é a foreign key das facts,
            e primary key dessa dimensão. Temos todos os meses do ano, e temos os anos de 2017 a 2024.

    - Realizar a curadoria dos dados, sempre priorizando fontes seguras brasileiras, como o IBGE. 
        -> Ex: tinhamos mais de 1 PIB dentre os datasets, o PIB priorizado foi o do IBGE.
    
 NOMENCLATURA:
    - A nomenclatura das views seguem o seguinte padrão:
        -> Caso seja uma dimensão: dim_fatores
*/

/* 
===========================================
          CRIANDO DIMENSÃO TEMPO
===========================================
*/

IF OBJECT_ID('gold.temp_dim_tempo') IS NOT NULL
    DROP TABLE gold.temp_dim_tempo
CREATE TABLE gold.temp_dim_tempo(
    id int identity(1,1) primary key not null, 
    nome nvarchar(20) not null);

--Tabela temporária para armazenar os valores e resetar ID's
INSERT INTO gold.temp_dim_tempo
SELECT CAST(ano as nvarchar) as 'Nome' FROM silver.ano
UNION
SELECT nome from silver.mes


CREATE VIEW gold.dim_tempo AS
select * from gold.temp_dim_tempo

/*
===================================================================
      CRIANDO DIMENSÃO DE FATORES ECONÔMICOS DO BRASIL
===================================================================
*/
CREATE VIEW gold.fact_fatores_economicos_brasil AS
WITH FatoresBrasilCalculados AS (
    SELECT
        sp.pibID,
        sp.ANO_PIB,
        CASE
            WHEN sp.ANO_PIB = 2 THEN 2018
            WHEN sp.ANO_PIB = 3 THEN 2019
            WHEN sp.ANO_PIB = 4 THEN 2020
            WHEN sp.ANO_PIB = 5 THEN 2021
            WHEN sp.ANO_PIB = 6 THEN 2022
            WHEN sp.ANO_PIB = 7 THEN 2023
            ELSE NULL 
        END AS AnoCalculado, -- Coluna 'Ano' calculada aqui dentro da CTE
        sp.PIB_VARIACAO,
        sp.VALOR_PIB_REAIS,
        sp.VALOR_PIB_DOLAR,
        sp.TAXA_CAMBIO_PIB,
        sp.PIB_PER_CAPITA_REAL,
        sp.POPULACAO_ESTIMADA,
        sib.DIVIDA_LIQUIDA_BRASIL,
        sib.DIVIDA_BRUTA_BRASIL,
        sib.DESPESA_BRASIL,
        sib.INFLACAO,
        std.taxa_desemprego,
        swd.inflation_cpi,
        swd.interest_rate,
        swd.inflation_gdp,
        swd.GDP_growth,
        swd.current_account_balance,
        swd.government_expense,
        swd.government_revenue,
        swd.tax_revenue,
        swd.gross_national_income,
        swd.public_debt,
        sib.ano_infos_brasil,
        std.ano_id,
        swd.year_wd
    FROM
        silver.pib AS sp
    JOIN
        silver.infos_brasil AS sib
    ON
        sp.ANO_PIB = sib.ano_infos_brasil
    JOIN
        silver.taxa_desemprego AS std
    ON
        sib.ano_infos_brasil = std.ano_id
    JOIN
        silver.world_data AS swd
    ON
        sp.ANO_PIB = swd.year_wd
    WHERE
        swd.country_name = 'Brazil' -- O filtro para 'Brazil'
)
SELECT
    fbc.pibID AS ID,
    fbc.ANO_PIB AS ano_id_origem, -- Mantendo o ID original do PIB se precisar
    gdt.id AS ano_id_dimensao, -- O ID da dimensão de tempo
    fbc.AnoCalculado AS Ano, -- O ano calculado (2018, 2019, etc.)
    fbc.PIB_VARIACAO AS variacao_pib,
    fbc.VALOR_PIB_REAIS AS valor_pib_reais,
    fbc.VALOR_PIB_DOLAR AS valor_pib_dolares,
    fbc.TAXA_CAMBIO_PIB AS taxa_cambio,
    fbc.PIB_PER_CAPITA_REAL AS pib_percapita_real,
    fbc.POPULACAO_ESTIMADA AS populacao,
    fbc.DIVIDA_LIQUIDA_BRASIL AS divida_liquida,
    fbc.DIVIDA_BRUTA_BRASIL AS divida_bruta,
    fbc.DESPESA_BRASIL AS despesa_brasil,
    fbc.INFLACAO AS inflacao,
    fbc.taxa_desemprego,
    fbc.inflation_cpi AS inflacao_cpi,
    fbc.interest_rate AS taxa_de_juros,
    fbc.inflation_gdp AS inflacao_gdp,
    fbc.GDP_growth AS crescimento_pib,
    fbc.current_account_balance AS balanca_pagamentos,
    fbc.government_expense AS despesas_governo,
    fbc.government_revenue AS receita_governo,
    fbc.tax_revenue AS receita_tributária,
    fbc.gross_national_income AS renda_nacional_bruta,
    fbc.public_debt AS divida_publica
FROM
    FatoresBrasilCalculados AS fbc -- Referenciando a CTE
JOIN
    gold.dim_tempo AS gdt
ON
    fbc.AnoCalculado = TRY_CAST(gdt.nome AS INT); -- Junção segura com TRY_CAST

select * from gold.fact_fatores_economicos_internacionais
/* 
===================================================================
      CRIANDO DIMENSÃO DE FATORES ECONÔMICOS INTERNACIONAIS
===================================================================
*/
CREATE VIEW gold.fact_fatores_economicos_internacionais AS
WITH WorldDataComAno AS (
    SELECT
        wdID,
        country_name,
        country_id,
        CASE
            WHEN year_wd = 1 THEN 2017
            WHEN year_wd = 2 THEN 2018
            WHEN year_wd = 3 THEN 2019
            WHEN year_wd = 4 THEN 2020
            WHEN year_wd = 5 THEN 2021
            WHEN year_wd = 6 THEN 2022
            WHEN year_wd = 7 THEN 2023
            WHEN year_wd = 8 THEN 2024
        END AS AnoCalculado, 
        inflation_cpi,
        gdp_wd,
        gdp_percapita,
        unemployment_rate,
        interest_rate,
        inflation_gdp,
        GDP_growth,
        current_account_balance,
        government_expense,
        government_revenue,
        tax_revenue,
        gross_national_income,
        public_debt
    FROM
        silver.world_data
    WHERE
        country_name NOT IN ('Brazil') 
)
SELECT
    wd.wdID AS 'ID',
    wd.country_name AS 'nome_do_pais',
    wd.country_id AS 'cod_pais',
    dtdt.id AS 'ano_id',
    wd.AnoCalculado AS ano, 
    wd.inflation_cpi AS 'inflacao_cpi',
    wd.gdp_wd AS 'pib',
    wd.gdp_percapita AS 'pib_percapita',
    wd.unemployment_rate AS 'taxa_desemprego',
    wd.interest_rate AS 'taxa_de_juros',
    wd.inflation_gdp AS 'inflacao_pib',
    wd.GDP_growth AS 'crescimento_pib',
    wd.current_account_balance AS 'balanca_pagamentos',
    wd.government_expense AS 'dispesas_governo',
    wd.government_revenue AS 'receita_governo',
    wd.tax_revenue AS 'receita_tributária',
    wd.gross_national_income AS 'renda_nacional_bruta',
    wd.public_debt AS 'divida_publica'
FROM
    WorldDataComAno AS wd 
JOIN
    gold.dim_tempo AS gdt
ON
    CAST(wd.AnoCalculado as nvarchar) = gdt.nome;


