#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function DoCase
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
User Function DoCase()
    Local cData := "20/12/2023"

    Do Case
        Case cData == "20/12/2023"
        Alert ("Não é Natal"  +  cData)

        Case cData == "25/12/2023"
        Alert ("É Natal!")

        OTHERWISE 
        MSGALERT("Não sei que dia é hoje!")

        EndCase
    
Return
