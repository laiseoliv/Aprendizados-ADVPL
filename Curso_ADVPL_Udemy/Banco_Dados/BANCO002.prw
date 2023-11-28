#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function BANCO002
description)
    @type  Function
    @author user
    @since 27/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

// é a mesma pega do codigo feito no arquivo **BANCO001**

User Function BANCO002()
    Local aArea := SB1->(GetArea())
    Local cMsg := ''

    DBSELECTAREA("SB1")
    SB1->(DBSETORDER(1))
    SB1->(DBGOTOP())

    cMsg := Posicione(  'SB1,',;  // retorna um campo qualquer da tabela, que eu irei especificar. Mesma função do DBSEEK
                         1,;   
                         FWXFilial('SB1') + '000002',;
                         'B1_DESC') 

    Alert("Descrição Produto: " + cMsg, "AVISO")

    RestArea(aArea)


    
Return
