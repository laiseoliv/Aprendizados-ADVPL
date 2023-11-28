#include "Protheus.ch"
#include "FWMVCDEF.CH" 
 
User Function CRMA980() ///cXXX1,cXXX2,cXXX3,cXXX4,cXXX5,cXXX6
 
Local aParam        := PARAMIXB  //
Local xRet          := .T.
Local lIsGrid       := .F.
//Local nLinha        := 0
//Local nQtdLinhas    := 0
//Local cRotMVC       := "CRMA980"
Local cIDPonto      := ''
Local cIDModel      := ''
//Local cIDForm       := ''
//Local cEvento       := ''
//Local cCampo        := ''
//Local cConteudo     := ''
//Local cMsg          := ''
//Local oObj          := NIL
 

 
If aParam <> NIL
 
    oObj        := aParam[1]
    cIDPonto    := aParam[2]
    cIDModel    := aParam[3]
    lIsGrid     := (Len(aParam) > 3)

    IF cIDPonto == "MODELCOMMITNTTS"//'FORMCOMMITTTSPRE' .OR. cIDPonto == "MODELCOMMITNTTS" //'FORMCOMMITTTSPOS'
            U_AtualizaBanco()
        
    EndIf
  
 
EndIf
 
Return xRet
 
