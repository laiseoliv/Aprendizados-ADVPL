#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#Include "TBIConn.ch" 
#include 'fileio.ch'
// CRIANDO O DIRETORIO - tentativa 1 N�O OFICIAL

User Function ContLog()
    Local nNovoDir := 0 // mudar para 0
    Local lRet     := EXISTDIR("C:\rotina_protheus\log")
    Local nHandle  

    
    if (lRet != .T.)
        MSGALERT("Diret�rio n�o existe")
        nNovoDir:= MAKEDIR("C:\rotina_protheus") // criar cada parte da pasta
        nNovoDir:= MAKEDIR("C:\rotina_protheus\log")
    else
         MSGINFO("Diretorio criado com sucesso")    
    endif
   
//------------------------------------------------------------
//   CRIANDO ARQUIVO
    

    nHandle := FCREATE("C:\rotina_protheus\log\LogRotina.txt", 0) 
    cData   := FWTimeStamp(2)
    cNomeRot := "Inicio da rotina - Banco"

    if nHandle <> -1
        FWRITE(nHandle, "Data e hora da execu��o: " + cData + CRLF)
        cNomeRot:= "Inicio da rotina - Banco"
        FWRITE(nHandle, cNomeRot + CRLF)

    else
        
        MSGALERT("Falha ao abrir ["+cArquivo+"]","Ferror " + cValToChar(fError()) )
            Return
        
    endif 

    FCLOSE(nHandle)
RETURN
    //----- abrindo arquivo
/*
    nHandle := FOPEN( character, numeric, numeric, LO )

    if nHandle <> -1 // nHandle geralmente se refere a um identificador ou al�a (handle, em ingl�s) de um objeto ou recurso. Um "handle" � um valor que � usado para identificar de forma �nica um objeto ou recurso dentro do ambiente ADVPL. O uso de "handles" � comum em programa��o para gerenciar recursos, como arquivos, conex�es de banco de dados, janelas de interface do usu�rio e outros objetos. Por exemplo, em ADVPL, voc� pode obter um "handle" para um arquivo que voc� abriu usando a fun��o fCreate(). Esse "handle" � um valor �nico que permite que voc� fa�a opera��es no arquivo, como ler, escrever ou fechar o arquivo.  
            
            FWRITE(nHandle, "Data e hora da execu��o: " + cData + CRLF)
            cNomeRot:= "Inicio da rotina - Banco"
            FWRITE(nHandle, cNomeRot + CRLF) //FWrite( < nHandle >, < cBuffer >, [ nQtdBytes ] ) // Indica a quantidade de bytes que ser�o escritos a partir da posi��o atual do ponteiro de arquivos. Caso n�o seja informado, todo o conte�do do par�metro � escrito.
        
       
        //if !EMPTY(AtualizaBanco())

            //mostrar os clientes alterados
        //endif  
    else
        conout("Erro ao criar arquivo - ferror " + Str(Ferror())) // // Verifica se o valor de nHandle � igual a -1. Se for igual a -1, isso indica que ocorreu um erro ao criar o arquivo. Nesse caso, ele imprime uma mensagem de erro no console usando a fun��o conout e inclui informa��es sobre o erro usando Str(Ferror()), que converte o c�digo de erro em uma string.
    endif

    FClose(nHandle)
RETURN 




/////// ******* ALGUMAS TENTATIVAS *************
/*
Static Function VerificaCliente()
    Local aClientes := U_AtualizaBanco()
    Local cMsgInfo
    Local nCount := 0
    Local cCLiente

    if LEN(aClientes) > 0
        cMsgInfo := (" Clientes com registros alterados: " + CLRF)
            for nCount := 1 TO len(aClientes)
                cCLiente := aClientes[nCount]
                FWrite(nHandle, "Cliente Alterado: " + cCliente + CRLF)
            next
    else
        cMsgInfo := ("N�o h� registro de clientes alterados." + CRLF)
    endif
Return
 */


/*
Static Function OpenArq()
    Local cData
    Local cNomeRot
    Local nHandle := 1 

    if nHandle >= 1
        nHandle:= FOPEN("C:\rotina_protheus\log\LogRotina.txt", FO_READWRITE + FO_SHARED )
        cData := FWTimeStamp(2)
        FWRITE(nHandle, "Data e hora da execu��o: " + cData + CRLF)
        cNomeRot:= "Inicio da rotina"
        FWRITE(nHandle, cNomeRot + CRLF)
        
    else
        conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
     
    endif
    FClose(nHandle)
Return 

//////-------- vendo condi��es ---------------
while nHandle (!EOF())
    FSEEK(nHandle, 0)
    
end


/*

//---------------------------
Static Function VerificaCliente(nHandle)
    LOCAL lClientesAl := .F.
    Local cMsgInfo:= ""

    if !lClientesAl
        cMsgInfo := ("Nenhum cliente alterado." + CRLF)
        FWrite(nHandle, cMsgInfo)
    else
        cMsgInfo := ("Clientes com registros alterados:" + CRLF)
        FWrite(nHandle, cMsgInfo)

        
    endif

    
Return 

*/










