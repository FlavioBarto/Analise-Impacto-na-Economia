
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
    
*/

/* 
===========================================
          CRIANDO DIMENSÃO TEMPO
===========================================
*/

CREATE VIEW gold.dim_ano
SELECT ano FROM silver.ano

CREATE VIEW gold.dim_mes
SELECT nome from silver.mes

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
    gda.ano_id AS ano_id, -- O ID da dimensão de tempo
    fbc.AnoCalculado AS Ano, -- O ano calculado (2018, 2019, etc.)
    fbc.PIB_VARIACAO AS variacao_pib,
    fbc.VALOR_PIB_REAIS AS valor_pib_reais,
    fbc.VALOR_PIB_DOLAR AS valor_pib_dolares,
    TRY_CAST(fbc.TAXA_CAMBIO_PIB as float)/100 AS taxa_cambio, --Divido por 100(%)
    fbc.PIB_PER_CAPITA_REAL AS pib_percapita_real,
    fbc.POPULACAO_ESTIMADA AS populacao,
    fbc.DIVIDA_LIQUIDA_BRASIL/100 AS divida_liquida,
    fbc.DIVIDA_BRUTA_BRASIL/100 AS divida_bruta, --Divido por 100(%)
    fbc.DESPESA_BRASIL/100 AS despesa_brasil, --Divido por 100(%)
    fbc.INFLACAO/100 AS inflacao, --Divido por 100(%)
    fbc.taxa_desemprego/100 as taxa_desemprego, --Divido por 100(%)
    fbc.inflation_cpi/100 AS inflacao_cpi, --Divido por 100(%)
    fbc.inflation_gdp/100 AS inflacao_gdp, --Divido por 100(%)
    fbc.GDP_growth/100 AS crescimento_pib, --Divido por 100(%)
    fbc.current_account_balance/100 AS balanca_pagamentos, --Divido por 100(%)
    fbc.government_expense/100 AS despesas_governo, --Divido por 100(%)
    TRY_CAST(fbc.government_revenue as float)/100 AS receita_governo,  --Divido por 100(%)
    fbc.gross_national_income AS renda_nacional_bruta
FROM
    FatoresBrasilCalculados AS fbc -- Referenciando a CTE
JOIN
    silver.ano AS gda
ON
    fbc.AnoCalculado = gda.ano; -- Junção segura com TRY_CAST | 28.5828852342878
    select * from silver.ano

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
        inflation_gdp,
        GDP_growth,
        current_account_balance,
        government_expense,
        government_revenue,
        tax_revenue,
        gross_national_income
    FROM
        silver.world_data
    WHERE
        country_name NOT IN ('Brazil') 
)
SELECT
    wd.wdID AS 'ID',
    wd.country_name AS 'nome_do_pais',
    wd.country_id AS 'cod_pais',
    gda.ano_id AS 'ano_id',
    wd.AnoCalculado AS ano, 
    TRY_CAST(wd.inflation_cpi as float)/100 AS 'inflacao_cpi',
    wd.gdp_wd AS 'pib',
    wd.gdp_percapita AS 'pib_percapita',
    TRY_CAST(wd.unemployment_rate as float)/100 AS 'taxa_desemprego',
    TRY_CAST(wd.inflation_gdp as float)/100 AS 'inflacao_pib',
    TRY_CAST(wd.GDP_growth as float)/100 AS 'crescimento_pib',
    TRY_CAST(wd.current_account_balance as float)/100 AS 'balanca_pagamentos',
    TRY_CAST(wd.government_expense as float)/100 AS 'dispesas_governo',
    TRY_CAST(wd.government_revenue as float)/100 AS 'receita_governo',
    TRY_CAST(wd.tax_revenue as float)/100 AS 'receita_tributária',
    wd.gross_national_income AS 'renda_nacional_bruta'
FROM
    WorldDataComAno AS wd 
JOIN
    silver.ano AS gda
ON
    wd.AnoCalculado = gda.ano;

/* 
===========================================
        CRIANDO DIMENSÃO TAXA CAMBIO
===========================================
*/

CREATE VIEW gold.fact_taxa_cambio AS
WITH TaxaCambioTransformada AS (
    SELECT 
        st.dia_taxa_cambio, 
        st.mes_taxa_cambio,
        st.ano_taxa_cambio AS ano_id,
        CASE 
            WHEN st.ano_taxa_cambio = 1 THEN 2017
            WHEN st.ano_taxa_cambio = 2 THEN 2018
            WHEN st.ano_taxa_cambio = 3 THEN 2019
            WHEN st.ano_taxa_cambio = 4 THEN 2020
            WHEN st.ano_taxa_cambio = 5 THEN 2021
            WHEN st.ano_taxa_cambio = 6 THEN 2022
            WHEN st.ano_taxa_cambio = 7 THEN 2023
        END AS ano,
        st.valor_taxa_cambio
    FROM silver.taxa_cambio st
)
SELECT 
    tct.ano_id, 
    tct.dia_taxa_cambio, 
    tct.mes_taxa_cambio, 
    tct.valor_taxa_cambio
FROM TaxaCambioTransformada tct
JOIN silver.ano gdt_ano ON tct.ano = gdt_ano.ano
JOIN silver.mes sm ON tct.mes_taxa_cambio = sm.mes_id;

