#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function EstrutWhile
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
User Function EstrutWhile()
    Local nNum1 := 1
    Local cNome := "SOSYS"
    //Local nNum2 := 10

    while nNum1 != 10 .AND. cNome != "PROTHEUS"
        nNum1++
            if nNum1 == 10
            cNome := "PROTHEUS"                
            endif
    ENDDO
        Alert("Numero: " + CVALTOCHAR( nNum1))
        Alert("Nome: " + CVALTOCHAR( cNome))


/*
while nNum1 < nNum2

    nNum1++
end
    Alert(nNum1 + nNum2)
 */   
Return 
