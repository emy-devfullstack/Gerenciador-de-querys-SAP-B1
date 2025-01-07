SELECT DISTINCT ODRF."DocDate"
	,CASE 
		WHEN (ODRF."ObjType" = '22')
			THEN 'Pedido'
		WHEN (ODRF."ObjType" = '1470000113')
			THEN 'Solicitação'
		END AS "Tipo de Documento"
	,ODRF."DocEntry" AS "Nº Esboço"
	,ODRF."DocNum" AS "Nº Solicitação Compra"
	,DRF1."BaseDocNum"
	,CASE 
		WHEN (
				ODRF."CANCELED" = 'N'
				AND ODRF."DocStatus" = 'O'
				)
			THEN 'Aberto'
		WHEN (
				ODRF."CANCELED" = 'N'
				AND ODRF."DocStatus" = 'C'
				)
			THEN 'Fechado'
		ELSE 'Cancelado'
		END AS "Status do Documento"
	,OITM."ItemCode"
	--,INITCAP(OITM."ItemName")
	,DRF1."Quantity"
	,DRF1."Price"
	,DRF1."U_TX_DescMatNfse"
	,ODRF."Comments"
	,DRF1."Project"
	,CASE 
		WHEN OHEM."firstName" IS NULL
			THEN INITCAP(SUBSTR_BEFORE(ODRF."ReqName", ' ') || substr(ODRF."ReqName", instr(ODRF."ReqName", ' ', - 1), 100))
		ELSE INITCAP(OHEM."firstName" || ' ' || substr(OHEM."lastName", instr(OHEM."lastName", ' ', - 1), 100))
		END AS "Autor do Doc."
	,CASE 
		WHEN OUDP."Name" IS NULL
			THEN (
					SELECT Cad_Dep."Name"
					FROM "SUA_TABELA"."OHEM" Cad_Colaborador
					INNER JOIN "SUA_TABELA"."OUDP" Cad_Dep ON Cad_Colaborador."dept" = Cad_Dep."Code"
					WHERE Cad_Colaborador."empID" = OHEM."empID"
					)
		ELSE OUDP."Name"
		END AS "Departamento"
	,CASE 
		WHEN (OWDD."Status" = 'Y')
			THEN 'Aprovado'
		WHEN (OWDD."Status" = 'W')
			THEN 'Pendente'
		WHEN (OWDD."Status" = 'N')
			THEN 'Recusado'
		END AS "Aprovação do Esboço"
	,INITCAP(OUSR."U_NAME") AS "Aprovador"
	,CASE 
		WHEN (WDD1."Status" = 'Y')
			THEN 'Autorizado'
		WHEN (WDD1."Status" = 'W')
			THEN 'Pendente'
		WHEN (WDD1."Status" = 'N')
			THEN 'Recusado'
		END AS "Resposta Aprovador"
	,CASE 
		WHEN (ODRF."ObjType" = '1470000113')
			THEN CAST((
						SELECT OPRQ."DocNum"
						FROM "SUA_TABELA"."OPRQ" OPRQ
						WHERE OPRQ."draftKey" = ODRF."DocEntry"
						) AS NVARCHAR(50))
		WHEN (ODRF."ObjType" = '22')
			THEN CAST((
						SELECT PO."DocNum"
						FROM "SUA_TABELA"."OPOR" PO
						WHERE PO."draftKey" = ODRF."DocEntry"
						) AS NVARCHAR(50))
		ELSE 'Sem Doc'
		END AS "Relacionamento"
FROM "SUA_TABELA"."ODRF" ODRF
INNER JOIN "SUA_TABELA"."DRF1" DRF1 ON DRF1."DocEntry" = ODRF."DocEntry"
INNER JOIN "SUA_TABELA"."OITM" OITM ON OITM."ItemCode" = DRF1."ItemCode"
INNER JOIN "SUA_TABELA"."OWDD" OWDD ON ODRF."DocEntry" = OWDD."DraftEntry"
INNER JOIN "SUA_TABELA"."WDD1" WDD1 ON OWDD."WddCode" = WDD1."WddCode"
INNER JOIN "SUA_TABELA"."OWST" OWST ON WDD1."StepCode" = OWST."WstCode"
INNER JOIN "SUA_TABELA"."WST1" WST1 ON OWST."WstCode" = WST1."WstCode"
	AND WST1."UserID" = WDD1."UserID"
INNER JOIN "SUA_TABELA"."OUSR" OUSR ON WST1."UserID" = OUSR."USERID"
LEFT JOIN "SUA_TABELA"."OHEM" OHEM ON OHEM."empID" = ODRF."OwnerCode"
LEFT JOIN "SUA_TABELA"."OUDP" OUDP ON OUDP."Code" = ODRF."Department"
LEFT JOIN "SUA_TABELA"."POR1" POR1 ON ODRF."DocNum" = POR1."BaseDocNum"
	AND POR1."ItemCode" = DRF1."ItemCode"
LEFT JOIN "SUA_TABELA"."OPOR" OPOR ON POR1."DocEntry" = OPOR."DocEntry"
WHERE (
		ODRF."DocDate" BETWEEN [%0]
			AND [%1]
		)
	AND (
		CASE 
			WHEN WDD1."Status" = 'Y'
				AND OUSR."USERID" = '1'
				OR WDD1."Status" = 'Y'
				AND OUSR."USERID" != '1'
				THEN 1
			WHEN WDD1."Status" = 'W'
				AND OUSR."USERID" = '1'
				THEN 0
			WHEN WDD1."Status" = 'W'
				AND OUSR."USERID" != '1'
				THEN 1
			WHEN WDD1."Status" = 'N'
				AND OUSR."USERID" = '1'
				OR WDD1."Status" = 'N'
				AND OUSR."USERID" != '1'
				THEN 1
			END = 1
		)
ORDER BY ODRF."DocDate"
	,ODRF."DocDate"
	,ODRF."DocEntry"
	,OITM."ItemCode";
