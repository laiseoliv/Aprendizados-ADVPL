#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function Estrutur
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
User Function Estrutur()
    Local nNum1 := 22
    Local nNum2 := 100



    if (nNum1 = nNum2)
        MSGINFO("A variavel nNum1 e igual a nNum2")
    
    elseif (nNum1 > nNum2)
        MSGALERT("A variavel  nNum é maior que nNum 2")

    elseif (nNum1 != nNum2)
        Alert ("A variavel nNum1 e diferente de nNum2")


    /*    
    else
        Alert("A variavel  nNUm1 nao e igual ou menor a nNum1")
     */

    endif

    
Return 
