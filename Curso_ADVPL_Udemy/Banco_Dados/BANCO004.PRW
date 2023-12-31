#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function BANCO004
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
User Function BANCO004()
    Local aArea := SB1 ->(GetArea())

    DBSELECTAREA('SB1')
    SB1->(DBSETORDER(1))
    SB1->(DBGOTOP())

    // Iniciar a transa��o.
    Begin Transaction // VAI TRAVAR A TABEELA PARA QUE ELA SEJA DE USO EXCLUSIVO DA TABELA
        MSGINFO("A descri��o do produto ser� alterada!", "Aten��o")

    if SB1-> (DBSEEK(FWXFilial('SB1') + '000002'))
        RECLOCK('SB1', .F.) // nesse caso de RECLOCK o uso do false(.F.), informa que trva o registro para alterar uma informa��o no banco de dados. Se eu colocasse .T.(true), eu travaria para incluir uma informa��o
    Replace B1_DESC With "MONITOR DELL 42 PL"  //n�o colocar .T. no RECLOCK para Incluir algo na tabela padr�o de sistema, devido ao relacionamento com outras tabelas. Nesse caso � apenas para exemplo
        
        SB1->(MSUNLOCK()) 

    endif
        MSGALERT("Altera��o efetuada!", "Aten��o")

    End Transaction
    RestArea(aArea)

Return
