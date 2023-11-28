#INCLUDE "Protheus.ch"
#INCLUDE 'TBICONN.CH'


User Function teste() 

/*

Objetivo:
    Atualizar um campo em uma tabela '341' '104' campo = "A1_BCO1"

Solução:
    Buscar os clientes que tem o campo vazio - ok
    Loop
        Atualizar o campo A1_BCO1
            Seleciona o registro
            Lock do registro
            Alteração dos campos
            Unlock do registro
            Passar pro próximo
    Chegou depois do último registro ou registro diferente do campo A1_BCO1 vazio

Fim
*/

    Local cQuery := ''

// Busca pelo SQL
    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
   
    IIF( Select('T_SA1')  !=0, T_SA1->(DbCLoseArea()  ), )
    cQuery := "SELECT A1_FILIAL, A1_COD, A1_LOJA FROM SA1990 WHERE A1_BCO1 = ''"
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "T_SA1", .T., .T. )

 

    While T_SA1->(!Eof()) // Quando acabar os registros da área temporária ele sai do While

        // Atualizar o campo A1_BCO1
        // Selecionar o registro com seek

        DBSELECTAREA('SA1')
        DBSETORDER(1) // A1_FILIAL + A1_COD + A1_LOJA

        if DbSeek(T_SA1->A1_FILIAL + T_SA1->A1_COD + T_SA1->A1_LOJA) // vai varrer a tabela SA1, nos campos filia, codigo e loja
            RECLOCK('SA1', .F.) // vai alterar o registro no banco de dados, o .F. informa que será alterado
                if ehpar(T_SA1->A1_COD) // se o codigo do cliente for par
                    SA1->A1_BCO1 := '104' // altera para o banco 104
                else
                    SA1->A1_BCO1 := '341' // se não, altera para o banco 341
                endif
            MSUNLOCK() // fecha o reclock
        endif  

        T_SA1->(DbSkip()) // Comando para passar para o próximo registro
    End

    IIF( Select('T_SA1')  !=0, T_SA1->(DbCLoseArea()  ), )

    RESET ENVIRONMENT

return

 

Static Function ehpar(cCodigo) // foi criado uma Static Function

   

return (Val(cCodigo) % 2) == 0
