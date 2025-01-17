SELECT T0."DocNum" AS "Nº Pedido"
                ,T0."NumAtCard"
	,T0."DocStatus"
	,T2."Serial" AS "NFe Emitida"
	,T0."CardCode" AS "Cod. Cliente"
	,T0."CardName" AS "Nome Cliente"
	,T0."Address2" AS "Endereço entrega"
	,T0."DocDate" AS "Dt. Emissão"
	,T0."DocDueDate" AS "Dt. Fat"
	,T1."ItemCode" AS "Cod. Item"
	,T1."Dscription" AS "Descrição item"
	,T1."Quantity" AS "Qtde"
	,T1."DiscPrcnt" AS "% Desconto"
	,T1."LineTotal" AS "Valor linha"
	,T1."LineVat" + T1."DistribSum" AS "Valor impostos"
	,T0."SlpCode" "Cod. Vendedor"
	,T0."GroupNum" AS "Cond. Pgto"
	,T1."Usage" AS "Utilização"
              ,T1."U_CVA_Justificativa"
	,T0."Comments"
	,T0."U_CVA_Indicador" AS "Indicador"
	,T0."U_CVA_PenComercial"
	,T0."U_CVA_PenFinanceiro" 
FROM ORDR T0
INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
LEFT JOIN INV1 T3 on T3."BaseEntry" = T0."DocEntry"
LEFT JOIN OINV T2 ON T2."DocEntry" = T3."DocEntry"
WHERE T0."DocDueDate" >= [%0]
	AND T0."DocDueDate" <= [%1]
	AND T0."DocStatus" LIKE 'O%'