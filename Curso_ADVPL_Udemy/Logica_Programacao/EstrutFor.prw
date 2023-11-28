#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function EstrutFor
description)
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
User Function EstrutFor()
    Local nCount
    Local nNum := 0

    for nCount := 0 to 10 Step 2 // nesse acaso ele vai contar de 2 em 2 até 10.
    nNum += nCount
    //resultado sem o step é 55
    //resultado com o step é 30
        
    next
    Alert ("Valor: " + cValToChar(nNum))
    
Return
