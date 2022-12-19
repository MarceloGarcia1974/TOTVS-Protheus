#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
/*
Marcelo Garcia dos Santos
www.topconnect.com.br
marcelo.gsantos@gmail.com
https://www.linkedin.com/in/marceloadvogado/

Busca CEP via WebService do viacep.com.br
*/
User Function CHKCEP()
local aPergs    := {}

Private aLog    := {}
Private aTitle  := {}
private aParam  := {}

    aadd(aPergs, {1, 'CEP: ', space(8),,, '',,, .f.})
    if 	parambox(aPergs, 'Informe o CEP', aParam,,,,,,, 'CHKCEP', .t., .t.)
        cRetorno:=APICEP(aParam[1])
        MsgAlert(cRetorno, 'Retorno CEP '+aParam[1])
    endif

Return

Static Function APICEP(cCep)
local cUrl := "viacep.com.br/ws/"+cCEP+"/json"
local cGetParms := ""
local nTimeOut := 200
local aHeadStr := {"Content-Type: application/json"}
local cHeaderGet := ""
local cRetorno := ""
Local cRet
LOCAL oJson
	cRetorno := HttpGet( cUrl , cGetParms, nTimeOut, aHeadStr, @cHeaderGet )

        //cria objeto
        oJson:=JsonObject():new()
        //Efetuar o parser do JSON
        cError := oJson:fromJson(cRetorno) 

        If !Empty(cError) //ocorrencia de qualquer erro
            Return 'CEP Inválido'
        endif

        cRet:=oJson:GetJsonText("logradouro") //busca por um item do Json
        if cRet = 'null'
            Return 'CEP nao encontrado'
        endif

        cRet:="logradouro: "    + oJson:GetJsonText("logradouro") + CRLF
        cRet+="complemento: "   + oJson:GetJsonText("complemento") + CRLF
        cRet+="localidade: "    + oJson:GetJsonText("localidade") + CRLF
        cRet+="bairro: "        + oJson:GetJsonText("bairro") + CRLF
        cRet+="uf: "            + oJson:GetJsonText("uf") + CRLF
        cRet+="ibge: "          + oJson:GetJsonText("ibge") + CRLF
        cRet+="gia: "           + oJson:GetJsonText("gia") + CRLF
        cRet+="ddd: "           + oJson:GetJsonText("ddd") + CRLF
        cRet+="siafi: "         + oJson:GetJsonText("siafi")

	FreeObj(oJson)
Return cRet

