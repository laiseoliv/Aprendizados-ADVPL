#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function BANCO005
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
User Function BANCO005()
    Local aArea := GetArea()
    Local aDados := {}
    Private lMSErroAuto := .F.

    //Adicionando dados no vetor para teste de inclusão na tabela SB1
    aDados := { {"B1_COD",  "111111",         NIL},;
                {"B1_DESC", "PRODUTO TESTE",  NIL},;
                {"B1_TIPO", "GG",             NIL},;
                {"B1_UM", "PC",               NIL},;
                {"B1_LOCPAD",  "01",          NIL},;
                {"B1_PICM",     0,            NIL},;
                {"B1_IPI", 0,                 NIL},;
                {"B1_CONTRAT", "N",           NIL},;
                {"B1_LOCALIZ", "N",           NIL}}
                   
                
    
    // Inicio do controle de transação
    BEGIN Transaction
        //Chama cadastro de produto
    MSExecAuto({|x,y|MATA010(x,y)}, aDados, 3) //coloca os parametros nos || e depois das {} coloca o que vai em x, que é aDados, e y que é o 3(numero da operação, ou seja, tipo de operação que estamos fazendo. Pode ser 3-inclusão, 4-ALteração e 5-exclusão)
    
    //Caso ocorra um erro
        if lMSErroAuto
            Alert("Ocorreram erros durante a operação!")
            MostraErro()
            DisarmTransacttion()
        else
            MSGINFO("Operação finalizada!", "Aviso")
        endif

    End Transaction
    RestArea(aArea)

Return 
