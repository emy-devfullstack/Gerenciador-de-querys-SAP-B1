/*SELECT T0."DocDate" FROM OINV T0 WHERE T0."DocDate" =[%0]

                      
SELECT 
    T0."DocType" as "Tipo de documento",
	T0."ItemCode",
	T0."Dscription",
	T0."Quantity",
	T0."Price",
	T0."LineTotal" "LineTotal sem Suframa",
	T0."DistribSum",
	T0."IPI_TaxSum",
	T0."ICMSST_TaxSum",
	T0."FCPST_TaxSum",
	T0."DiscPrcnt",
	T0."ICMS_U_ExcAmtL",
              T0."PIS_TaxSum",
              T0."COFINS_TaxSum",
              T0."ICMS_TaxSum",
              T0."TotalCost",
	T0."PriceBefDi",
	T0."DiscPrcntLine",
	T0."DocDueDate",
	'' "Data Faturamento",
	0 "Numero NF",
	T0."StatusNf",
	T0."DocNum",
	T0."CardCode", 
	T0."CardName",
	T0."Utilizacao",
	T0."SlpName",
	T0."GroupNum",
	T1."PRAZOMEDIO" "Prazo Medio",
	CASE T0."BaseType" 
		WHEN 23 THEN 'COTAÇÃO'
		WHEN 17 THEN 'PEDIDO'
		WHEN 13 THEN 'NOTA FICAL DE SAIDA'
		END "Tipo Documento", 
	T0."BaseEntry",
	T0."BaseLine",
	T0."BaseRef"

	
	 FROM "CVA_PedidoItem" T0
	 	LEFT JOIN  "VW_PortalCVA_CondicaoPagamento_PrazoMedio" T1 ON T0."GroupNum" = T1."CODIGO"
	 	WHERE 0=0
     AND T0."DocDate"  >=   [%0] AND T0."DocDate"   <=   [%1] 


UNION ALL */
SELECT T0."DocType" AS "Tipo de documento"
	,T0."ItemCode"
	,T0."Dscription"
	,T0."Quantity"
	,T0."Price"
	,T0."LineTotal" "LineTotal sem Suframa"
	,T0."DistribSum"
	,T0."IPI_TaxSum"
	,T0."ICMSST_TaxSum"
	,T0."FCPST_TaxSum"
	,T0."DiscPrcnt" "% de desconto para documento"
	,T0."ICMS_U_ExcAmtL"
	,T0."PIS_TaxSum"
	,T0."COFINS_TaxSum"
	,T0."ICMS_TaxSum"
	,T0."TotalCost"
	,T0."PriceBefDi"
	,T0."DiscPrcntLine"
	,T0."DocDueDate" "Data de vencimento"
	,T0."DocDate" "Data Faturamento"
	,T0."Serial" "Numero NF"
	,T0."StatusNf"
	,T0."DocNum" "Nº do documento"
	,T0."CardCode" "Código do cliente/fornecedor"
	,T0."CardName" "Nome do cliente/fornecedor"
	,T0."Utilizacao"
	,T0."SlpName"
	,T0."GroupNum" "Código da condição de pagamento"
	,T1."PRAZOMEDIO" "Prazo Medio"
	,CASE T0."BaseType"
		WHEN 23
			THEN 'COTAÇÃO'
		WHEN 17
			THEN 'PEDIDO'
		WHEN 13
			THEN 'NOTA FICAL DE SAIDA'
		END "Tipo Documento"
	,T0."BaseEntry" "Chave interna do documento base"
	,T0."BaseLine"
	,T0."BaseRef"
FROM "SUA_TABELA" T0
LEFT JOIN "SUA_TABELA" T1 ON T0."GroupNum" = T1."CODIGO"
WHERE 0 = 0
	AND T0."DocDate" >= [%0]
	AND T0."DocDate" <= [%1]
