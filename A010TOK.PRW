/*
Marcelo Garcia dos Santos
www.topconneect.com.br
marcelo.gsantos@gmail.com
https://www.linkedin.com/in/marceloadvogado/

Ponto de entrada
A010TOK: Valida��o para inclus�o ou altera��o do Produto

Utilizado para copiar o cadastro de um produto para outras filiais durante a cria��o do mesmo.
*/

User Function A010TOK
Local aArea := GetArea()
Local lRet := .T.
Local cMsg := "Deseja incluir este produto nas demais Filiais?"
Local nI := 0
Local cEmp := '01'
Local cFilx:=CFILANT
Local cEmpx:=CEMPANT
Private aEmpresas := {{'01','01'},{'01','02'},{'01','03'}} //lista com as filias a receberem a c�pia

If inclui
    //mostra pergunta do parametro cMsg
	If ApMsgNoYes(cMsg, "Copiar")
		For nI := 1 To Len(aEmpresas)
			if (aEmpresas[nI][2] <> cFilx) //desprezar a filial logada
				RPCSetType(3)  //Nao consome licensas
				RpcSetEnv(cEmp,aEmpresas[nI][2],,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas autom�ticas
				SB1->(RecLock("SB1",.T.))
				MsgRun("Incluindo produto na filial "+aEmpresas[nI][2],"Aguarde....",{|| AvReplace("M","SB1") } ) 
				//altero a filial do produto (SB1)
				SB1->B1_FILIAL := aEmpresas[nI][2]

				SB1->(MsUnlock())
				RpcClearEnv()
			endif
		Next
		//Voltar ambientacao anterior
		RpcSetEnv(cEmpx,cFilx,,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas autom�ticas
	Endif
Endif

RestArea(aArea)
Return lRet