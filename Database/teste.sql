SELECT
    sp.pibID AS ID,
    sp.ANO_PIB,
    sp.PIB_VARIACAO,
    sp.VALOR_PIB_REAIS,
    sp.VALOR_PIB_DOLAR,
    sp.TAXA_CAMBIO_PIB,
    sp.PIB_PER_CAPITA_REAL,
    sp.POPULACAO_ESTIMADA,
    -- Colunas adicionadas da silver.infos_brasil
    sib.DIVIDA_LIQUIDA_BRASIL,
    sib.DIVIDA_BRUTA_BRASIL,
    sib.DESPESA_BRASIL,
    sib.INFLACAO,
    std.ano_id,
    std.taxa_desemprego
FROM
    silver.pib AS sp 
JOIN
    silver.infos_brasil AS sib 
ON
    sp.ANO_PIB = sib.ano_infos_brasil 
JOIN silver.taxa_desemprego std ON sib.ano_infos_brasil = std.ano_id;

select * from silver.infos_brasil;

select * from silver.world_data

select * from silver.taxa_desemprego