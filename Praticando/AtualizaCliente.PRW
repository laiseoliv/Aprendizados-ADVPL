#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#Include "TBIConn.ch" 
#include 'fileio.ch'
#Include "Restful.ch"
#Include "Totvs.ch"
#INCLUDE "RWMAKE.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 11/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (https://terminaldeinformacao.com/knowledgebase/execauto-MATA030-mvc/)
         (https://tdn.totvs.com/display/public/framework/FWFormModel)

         ***ExecAutoCRMA980 - ATUALIZAÇÃO DE UMA ROTINA DE CADASTRO DE CLIENTE AUTOMATICAMENTE***
    /*/
User Function ExecAutCliente()

Local aSA1Auto := {}
Local aAI0Auto := {}
Local nOpcAuto := 3  //MODEL_OPERATION_INSERT (3-Inclusão, 4-Alteração, 5-Exclusão)
Local lRet := .T.    

Private lMsErroAuto := .F.    

lRet := RpcSetEnv("99","01")  //Empresa "99", Filial "01"

If lRet
    //----------------------------------
    // INCLUSÃO
    //----------------------------------
    IF nOpcAuto = 3  //Inclusão
        ConOut("Teste de Inclusao")
        ConOut("Inicio: " + Time())
        //----------------------------------
        // DADOS DO CLIENTE
        //----------------------------------
        aAdd(aSA1Auto,{"A1_COD"         ,"000011"            ,Nil}) // Codigo
        aAdd(aSA1Auto,{"A1_LOJA"        ,"01"                ,Nil}) // Loja
        aAdd(aSA1Auto,{"A1_NOME"        ,"Teste PF"          ,Nil}) // Nome
        aAdd(aSA1Auto,{"A1_END"         ,"Rua Moçambique"    ,Nil}) // Endereco
        aAdd(aSA1Auto,{"A1_NREDUZ"      ,"Teste PF"          ,Nil}) // Nome Fantasia
        aAdd(aSA1Auto,{"A1_TIPO"        ,"F"                 ,Nil}) // Tipo
        aAdd(aSA1Auto,{"A1_EST"         ,"RS"                ,Nil}) // Estado
        aAdd(aSA1Auto,{"A1_COD_MUN"     ,"14902"             ,Nil})
        aAdd(aSA1Auto,{"A1_MUN"         ,"PORTO ALEGRE"      ,Nil}) // Municipio
        aAdd(aSA1Auto,{"A1_CEP"         ,"91260530"          ,Nil})
        aAdd(aSA1Auto,{"A1_CGC"         ,"43048733000"       ,Nil})
        CONOUT("Passou pelo Array da SA1")        

            //---------------------------------------
            // DADOS DO COMPLEMENTO DO CLIENTE
            //---------------------------------------
            //aAdd(aAI0Auto,{"AI0_SALDO" ,30 ,Nil})
            //CONOUT("Passou pelo Array da AI0")        

            //------------------------------------
            // Chamada para cadastrar o cliente
            //------------------------------------
        CONOUT("Iniciando a gravacao")
        MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)        

            If lMsErroAuto
                lRet := lMsErroAuto
                MostraErro()  // Nao funciona na execucao via JOB
            Else
                Conout("Cliente incluido com sucesso!")
            EndIf

            ConOut("Fim: " + Time())

        //----------------------------------
        // ALTERAÇÃO
        //----------------------------------
 /* ElseIf nOpcAuto = 4  //Alteração

            ConOut("Teste de Alteracao")
            ConOut("Inicio: " + Time())

            //----------------------------------
            // DADOS DO CLIENTE
            //----------------------------------
            aAdd(aSA1Auto,{"A1_COD"         ,"000011"            ,Nil}) // Codigo
            aAdd(aSA1Auto,{"A1_LOJA"        ,"01"                ,Nil}) // Loja
            aAdd(aSA1Auto,{"A1_NOME"        ,"Teste PF"          ,Nil}) // Nome
            aAdd(aSA1Auto,{"A1_END"         ,"Rua Moçambique"    ,Nil}) // Endereco
            aAdd(aSA1Auto,{"A1_NREDUZ"      ,"Teste PF"          ,Nil}) // Nome Fantasia
            aAdd(aSA1Auto,{"A1_TIPO"        ,"F"                 ,Nil}) // Tipo
            aAdd(aSA1Auto,{"A1_EST"         ,"RS"                ,Nil}) // Estado
            aAdd(aSA1Auto,{"A1_COD_MUN"     ,"14902"              ,Nil})
            aAdd(aSA1Auto,{"A1_MUN"         ,"SAO PAULO"          ,Nil}) // Municipio
            aAdd(aSA1Auto,{"A1_CEP"         ,"91260530"           ,Nil})
            aAdd(aSA1Auto,{"A1_CGC"         ,"43048733000"        ,Nil})
            CONOUT("Passou pelo Array da SA1")        
        
            //---------------------------------------
            // DADOS DO COMPLEMENTO DO CLIENTE
            //---------------------------------------
            //aAdd(aAI0Auto,{"AI0_SALDO" ,30 ,Nil})
            //CONOUT("Passou pelo Array da AI0")        

            //------------------------------------
            // Chamada para alterar o cliente
            //------------------------------------
            CONOUT("Iniciando a alteracao")
            MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)        

            If lMsErroAuto
                lRet := lMsErroAuto
                MostraErro()  // Nao funciona na execucao via JOB
            Else
                Conout("Cliente alterado com sucesso!")
            EndIf

            ConOut("Fim: " + Time())

        //----------------------------------
        // EXCLUSÃO
        //----------------------------------
  /*ElseIf nOpcAuto = 5  //Exclusão

            ConOut("Teste de Exclusao")
            ConOut("Inicio: " + Time())

            //----------------------------------
            // DADOS DO CLIENTE
            //----------------------------------
            aAdd(aSA1Auto,{"A1_COD"    ,"XBX141"            ,Nil}) // Codigo
            aAdd(aSA1Auto,{"A1_LOJA"   ,"01"                ,Nil}) // Loja
            CONOUT("Passou pelo Array da SA1")

            //------------------------------------
            // Chamada para excluir o cliente
            //------------------------------------
            CONOUT("Iniciando a exclusao")
            MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)        

            If lMsErroAuto
                lRet := lMsErroAuto
                MostraErro()  // Nao funciona na execucao via JOB
            Else
                Conout("Cliente excluido com sucesso!")
            EndIf

            ConOut("Fim: " + Time())*/

    EndIf

EndIf    

    RpcClearEnv() 

Return lRet
