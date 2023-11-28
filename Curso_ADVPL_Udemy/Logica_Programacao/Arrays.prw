#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function AVERTdescription)
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
User Function AVETOR()
    Local dData := DATE()
    Local aValores := {"Joao",dData,100}

    Alert(aValores[2])
    Alert(aValores[3])
    Alert(aValores[1])

    
Return
