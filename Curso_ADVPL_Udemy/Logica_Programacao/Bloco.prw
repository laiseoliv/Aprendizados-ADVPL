#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function bBloco
    (long_description)
    @type  Function
    @author user
    @since 26/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function bBloco()
    //Local bBloco := {|| Alert("Olá Mundo!")}
        //Eval(bBloco)

    Local bBloco := {|cMsg| Alert(cMsg)}
        Eval (bBloco, "Ola mundo chuvoso!")
    
Return
