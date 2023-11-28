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


User Function Escopo1()
    //Variaveis Locais
    Local nVar0 := 1
    Local nVar1 := 20

    //Variavies private
    Private cPri := 'private!'

    //Varivael public
    Public __cPublic := 'RCTI'

    TestEscop(nVar0, @nVar1)
   
Return

//-----------------------------------------------------------

Static Function TestEscop(nValor1, nValor2)

    Local __cPublic := 'Alterei'
    Default nValor1 := 0

    //Alterando conteudo da variavel
    nValor2 := 10

    //mostrar conteudo da varival private
    Alert ("Private: "+ cPri)

    //Alterar valor da variavel public
    Alert("Publica: " + __cPublic)
    
Return
