#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#Include "TBIConn.ch" 
#include 'fileio.ch'
#Include "Restful.ch"
#Include "Totvs.ch"
#INCLUDE "RWMAKE.CH"

/*
Objetivo:

    Atualizar um campo em uma tabela '341' '104' campo = "A1_BCO1"


Solu��o:
    Buscar os clientes que tem o campo vazio - ok

   
    Loop
        Atualizar o campo A1_BCO1
            Seleciona o registro
            Lock do registro
            Altera��o dos campos
            Unlock do registro
            Passar pro pr�ximo
    Chegou depois do �ltimo registro ou registro diferente do campo A1_BCO1 vazio

Fim

tem menu de contexto


*/


 User Function AtualizaBanco()
    Local cQuery        := ""
    Local nNovoDir      := 0 // mudar para 0
    Local lRet          := EXISTDIR("C:\rotina_protheus\log")
    Local nHandle
    Local lNaoFeito     := .T.
    Local lCaixa        := .F.
    Local lItau         := .F.
    Local cArquivo      := "C:\rotina_protheus\log\LogRotina2.txt"
    Local cData         := FWTimeStamp(2)
    Local cNomeRot      := "Inicio da rotina - Banco"
    Local cNomeFim      := "Fim da Rotina - Banco"
    Local cSemCliente   := "Nenhum cliente sofreu altera��o"
    Local nId           := 0        
    
//------ verificando diretorio
    if  (lRet != .T.)
        CONOUT("Diret�rio n�o existe")
        nNovoDir:= MAKEDIR("C:\rotina_protheus") // criar cada parte da pasta
        nNovoDir:= MAKEDIR("C:\rotina_protheus\log")
        if nNovoDir <> 0
            CONOUT( FError() )
            RETURN
        endif
    else
        CONOUT("Diretorio j� criado.") //exibir no console
    ENDIF
//----- criando arquivo no diretorio


    nHandle := FOPEN(cArquivo, FO_READWRITE + FO_SHARED )
    If nHandle == -1
         nHandle := FCREATE(cArquivo,0) 
         if nHandle == -1
            RETURN (fError()) // fecha a fun��o e retona algo --nil    
        ENDIF
    Endif
    FSEEK(nHandle, 0, FS_END)
   
    FWRITE(nHandle, "Data e hora da execu��o: " + cData + CRLF)
    cNomeRot:= "Inicio da rotina - Banco"
    FWRITE(nHandle, cNomeRot + CRLF)

//----- pegando informa��es do banco de dados.

    //PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'         
    
 //      ***Seleciona o registro***

  
    IIF( Select('T_SA1')  !=0, T_SA1->(DbCLoseArea()  ), )  // esse c�digo fecha a �rea de dados 'T_SA1' se ela estiver aberta, e n�o faz nada se n�o estiver aberta. � uma maneira de garantir que a �rea de dados seja fechada quando necess�rio, evitando erros relacionados a �reas de dados n�o fechadas.
    cQuery := "SELECT A1_FILIAL, A1_COD, A1_LOJA FROM SA1990 WHERE A1_BCO1 = ' '"
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "T_SA1", .T., .T. )  

    nId:= SUPERGETMV("MV_SEQBCO", .F., 0) // NOME DA ROTINA, HELP(padr�o � .T., ))
    nId++ 
    PUTMV("MV_SEQBCO", nId)   
 
    while T_SA1->(!EOF())
        DBSELECTAREA('SA1') //Seleciona o registro, NO CASO A TABELA QUE SER� TRABALHADA
        DBSETORDER(1)
        
        if DBSEEK(T_SA1->A1_FILIAL + T_SA1->A1_COD + T_SA1->A1_LOJA)
            RECLOCK('SA1', .F.) //Lock do registro
                if ehPar(T_SA1->A1_COD) //Altera��o dos campos
                    SA1->A1_BCO1 := "104"
                    lCaixa:= .T.
                else
                    SA1->A1_BCO1 := "341"
                    lItau:= .T.
                ENDIF
                                
            MSUNLOCK() //Unlock do registro
               
            FWRITE(nHandle, "Cliente " + T_SA1->A1_COD + " com altera��o de registro" + CRLF )

        else 
            U_FELSZ0( CVALTOCHAR(nId)                                 ,;  //campo chave. ex.numero do pedido,codigo cliente
                      "Atualiza��o Banco Cliente"                     ,;  //rotina executada. Ex.: atualiza banco, inclui cliente, nome ponto de entrada
                      DATE()                                          ,;  // data da execu��o.. quando eu rodei esse codigo..
                      TIME()                                          ,;  // hora da excecu��o. Hora da execu��o
                      "Cliente n�o encontrado"                          ,;  // mensagem resumida... resumo do que aconteceu. Ex.: "erro ao alterar cliente"
                      "Registro de cliente n�o encontrado" ,;  // mensagem detalhada. Ex.: "CNPJ duplicado", algum erro mais longo, com mais detalhes.
                      "Reclok"                                        ,;  // tipo de opera��o. Ex.: altera��o, PUT, Reclock
                      '1'                                             ,;  //tipo de ocorrencia (1=ok, 2=erro(n�o encontrou o que deveria ser encontrado na rotina))
                      "")   // estrutura JSON enviada na requisi��o.
        ENDIF

        lNaoFeito:= .F.      // entrou no while mudou o valor de origem
        U_FELSZ0(   CVALTOCHAR(nId)                                 ,;  //campo chave. ex.numero do pedido,codigo cliente
                    "Atualiza��o Banco Cliente"                     ,;  //rotina executada. Ex.: atualiza banco, inclui cliente, nome ponto de entrada
                    DATE()                                          ,;  // data da execu��o.. quando eu rodei esse codigo..
                    TIME()                                          ,;  // hora da excecu��o. Hora da execu��o
                    "Clientes atualizados"                          ,;  // mensagem resumida... resumo do que aconteceu. Ex.: "erro ao alterar cliente"
                    "Clientes que tiveram o campo banco atualizado" ,;  // mensagem detalhada. Ex.: "CNPJ duplicado", algum erro mais longo, com mais detalhes.
                    "Reclok"                                        ,;  // tipo de opera��o. Ex.: altera��o, PUT, Reclock
                    '1'                                             ,;  //tipo de ocorrencia (1=ok, 2=erro(n�o encontrou o que deveria ser encontrado na rotina))
                    "")

        T_SA1->(DBSKIP())
    END

    if lNaoFeito 
        FWRITE(nHandle, cSemCliente + CRLF)
        U_FELSZ0(   CVALTOCHAR(nId)                                 ,;  //campo chave. ex.numero do pedido,codigo cliente
                    "Atualiza��o Banco Cliente"                     ,;  //rotina executada. Ex.: atualiza banco, inclui cliente, nome ponto de entrada
                    DATE()                                          ,;  // data da execu��o.. quando eu rodei esse codigo..
                    TIME()                                          ,;  // hora da excecu��o. Hora da execu��o
                    "Sem atualiza��o"                          ,;  // mensagem resumida... resumo do que aconteceu. Ex.: "erro ao alterar cliente"
                    "N�o houve atualiza��o em clientes" ,;  // mensagem detalhada. Ex.: "CNPJ duplicado", algum erro mais longo, com mais detalhes.
                    "Reclok"                                        ,;  // tipo de opera��o. Ex.: altera��o, PUT, Reclock
                    '1'                                             ,;  //tipo de ocorrencia (1=ok, 2=erro(n�o encontrou o que deveria ser encontrado na rotina))
                    "")
    endif

    if lCaixa
        FWRITE(nHandle, "Clientes banco Caixa" + CRLF )
        
    endif

    if lItau
        FWRITE(nHandle, "Clientes banco Itau" + CRLF )
    endif



     FWRITE(nHandle, cNomeFim + CRLF )
/*
      U_FELSZ0(   CVALTOCHAR(nId)                                 ,;  //campo chave. ex.numero do pedido,codigo cliente
                    "Atualiza��o Banco Cliente"                     ,;  //rotina executada. Ex.: atualiza banco, inclui cliente, nome ponto de entrada
                    DATE()                                          ,;  // data da execu��o.. quando eu rodei esse codigo..
                    TIME()                                          ,;  // hora da excecu��o. Hora da execu��o
                    "Sem atualiza��o"                          ,;  // mensagem resumida... resumo do que aconteceu. Ex.: "erro ao alterar cliente"
                    "N�o houve atualiza��o em CLientes" ,;  // mensagem detalhada. Ex.: "CNPJ duplicado", algum erro mais longo, com mais detalhes.
                    "Reclok"                                        ,;  // tipo de opera��o. Ex.: altera��o, PUT, Reclock
                    '1'                                             ,;  //tipo de ocorrencia (1=ok, 2=erro(n�o encontrou o que deveria ser encontrado na rotina))
                    "")
 */   

     
     FCLOSE(nHandle)



     IIF( Select('T_SA1')  !=0, T_SA1->(DbCLoseArea()  ), )

     RESET ENVIRONMENT

       
 Return


 Static Function ehPar(cCodigo)
       
 //Return (Val(cCodigo%2))==0 // erro
 return (Val(cCodigo) % 2) == 0


