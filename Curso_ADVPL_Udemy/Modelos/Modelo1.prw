#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function Modelo1
    (long_description)
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
User Function Modelo1()
    Local cAlias := "SB1"
    Local cTitulos := "Cadastro - AXCadastro"
    Local cVldExc := ".T."
    Local cVldAlt := ".T."

    AXCadastro(cAlias, cTitulos, cVldExc, cVldAlt)
    
Return NIL
