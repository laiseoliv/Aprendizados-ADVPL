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

    // Iniciar a transação.
    Begin Transaction // VAI TRAVAR A TABEELA PARA QUE ELA SEJA DE USO EXCLUSIVO DA TABELA
        MSGINFO("A descrição do produto será alterada!", "Atenção")

    if SB1-> (DBSEEK(FWXFilial('SB1') + '000002'))
        RECLOCK('SB1', .F.) // nesse caso de RECLOCK o uso do false(.F.), informa que trva o registro para alterar uma informação no banco de dados. Se eu colocasse .T.(true), eu travaria para incluir uma informação
    Replace B1_DESC With "MONITOR DELL 42 PL"  //não colocar .T. no RECLOCK para Incluir algo na tabela padrão de sistema, devido ao relacionamento com outras tabelas. Nesse caso é apenas para exemplo
        
        SB1->(MSUNLOCK()) 

    endif
        MSGALERT("Alteração efetuada!", "Atenção")

    End Transaction
    RestArea(aArea)

Return
