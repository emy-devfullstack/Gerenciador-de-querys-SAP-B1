SELECT DISTINCT
    T0."ItemCode",
    T0."ItemName",
    T6."UpdateDate" AS "Última modificação",
      
    CASE
        WHEN T0."validFor" = 'Y' THEN 'Sim'
        ELSE 'Não'
    END AS "Ativo",
    
    CASE
        WHEN T0."U_CbxForaLinha" = '0' THEN 'Sim'
        WHEN T0."U_CbxForaLinha" = '1' THEN 'Não'
        ELSE ''
    END AS "Fora de Linha",

    T0."U_LicImport",
    T0."U_Dumping",

    CASE
        WHEN T0."SellItem" = 'Y' THEN 'Sim'
        ELSE 'Não'
    END AS "Item de Venda",

    CASE
        WHEN T0. "U_ItemMacro" = 0 THEN 'Artesanato'
        WHEN T0. "U_ItemMacro" = 1 THEN 'Colas & Fitas'
        WHEN T0. "U_ItemMacro" = 2 THEN 'Cortes & Réguas'
        WHEN T0. "U_ItemMacro" = 3 THEN 'Costurados'
        WHEN T0. "U_ItemMacro" = 4 THEN 'Escrita & Pintura'
        WHEN T0. "U_ItemMacro" = 5 THEN 'Papéis'
        WHEN T0. "U_ItemMacro" = 6 THEN 'Suprimentos'
        WHEN T0. "U_ItemMacro" = 7 THEN 'Pedagógicos'
        ELSE ''
    END AS "Macrocategoria",

    T1."ItmsGrpNam",
    T0."U_CVA_Desc_SubGrupo",
    T0."U_Tx_Linha",
    T0."U_Tx_Colecao",
    T0."U_ItemSubstituto",
    T0."U_MotivoSubstituicao",

    CASE
        WHEN T0."BuyUnitMsr" = 'Pacote' THEN 'PCT'
        WHEN T0."BuyUnitMsr" = 'Caixa' THEN 'CX'
        WHEN T0."BuyUnitMsr" = 'Unidade' THEN 'UN'
        WHEN T0."BuyUnitMsr" = 'Tubo' THEN 'TUB'
        WHEN T0."BuyUnitMsr" = 'Pote' THEN 'POT'
        WHEN T0."BuyUnitMsr" = 'Kilograma' THEN 'KG'
        ELSE ''
    END AS "SKU",

    T0."U_TX_UTribEx",
    T0."U_TX_FtTribEx",
    T2."NcmCode",
    T0."U_TX_CodigoCest",
    T4."U_IPI_VALUE",

    CASE
        WHEN T0."ProductSrc" = '1' THEN 'Importado'
        WHEN T0."ProductSrc" = '2' THEN 'Importado'
        WHEN T0."ProductSrc" = '6' THEN 'Importado'
        ELSE 'Nacional'
    END AS "Origem",

    CASE
        WHEN T3."ISOriCntry" = 'CN' THEN 'China'
        WHEN T3."ISOriCntry" = 'BR' THEN 'Brasil'
        WHEN T3."ISOriCntry" = 'IN' THEN 'Índia'
        WHEN T3."ISOriCntry" = 'PY' THEN 'Paraguai'
        ELSE T3."ISOriCntry"
    END AS "País de Origem",

    T0."U_NumInmetro",

    CASE
        WHEN T0."U_NumInmetro" IS NULL OR T0."U_NumInmetro" = '' OR T0."U_NumInmetro" = '000000/0000'
        OR T0."U_NumInmetro" = 'N/A' OR T0."U_NumInmetro" = '0' THEN 'Não'
        ELSE 'Sim'
    END AS "Inmetro",
    
    T0."U_ItemComposicao",

    -- Códigos de barras separados
    T0."U_InnerCodBarras",
    T0."U_MasterCodBarras",
    T0."U_ProdCodBarras",
    T0."U_EmbCodBarras",

    T0."BVolume" AS "Volume (CUBAGEM)",
    T0."BWeight1" AS "Peso de Compra (PESO LÍQUIDO)",
    T0."SWeight1" AS "Peso de Venda (PESO BRUTO)"
    
FROM OITM T0
LEFT JOIN OITB T1
    ON T0."ItmsGrpCod" = T1."ItmsGrpCod"
LEFT JOIN ITM10 T3
    ON T0."CountryOrg" = T3."ISOriCntry"
LEFT JOIN ONCM T2
    ON T0."NCMCode" = T2."AbsEntry"
LEFT JOIN "@BRW_DADOS_NCM_LINHA" T4
    ON T2."NcmCode" = T4."Code"
LEFT JOIN OBCD T5
    ON T0."ItemCode" = T5."ItemCode"
LEFT JOIN (
    SELECT "ItemCode", MAX("UpdateDate") AS "UpdateDate"
    FROM AITM
    GROUP BY "ItemCode"
) T6
    ON T0."ItemCode" = T6."ItemCode"
WHERE
    T0."MatType" = 0
    AND T0."ItemCode" NOT IN ('3229', 'ITNOVO')
    AND T0."validFor" >= [%0]  
ORDER BY
    T0."ItemCode"
