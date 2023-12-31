#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'



/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 25/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function VARIAVEL()
    Local nNum:= 66 // tipo num�rico
    Local lLogic:= .T. // Tipo L�gico
    Local cCarac:= "String" // Tipo caracter, nesse caso � uma string
    Local dData:= DATE() // tipo data
    Local aNome:= {"Jo�o", "Maria", "Jos�"}// tipo array
    Local bBloco:= {|| nValor := 2, MsgAlert("O n�mero �: "+cValToChar(nValor),"")} // tipo bloco

    Alert (nNum)
    Alert (lLogic)
    Alert (cValToChar(cCarac))
    Alert (dData)
    Alert (aNome[1])
    Eval (bBloco)

Return 
