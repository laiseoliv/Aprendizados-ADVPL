#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"


User Function XTESTE(aXEmpFil)

DEFAULT aXEmpFil	:= {"99","01"}

//PREPARE ENVIRONMENT EMPRESA aXEmpFil[1] FILIAL aXEmpFil[2] FUNNAME FunName() TABLES "SM0"

ConOut("FUNCIONOU!")

//RESET ENVIRONMENT

Return .T.
