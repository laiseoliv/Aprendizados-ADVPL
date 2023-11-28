#INCLUDE 'protheus.ch'
#INCLUDE 'fileio.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TopConn.ch' 


User Function ArqCria()
Local nHandle
Local cArquivo := "C:\rotina_protheus\log\LogRotina2.txt"



// criando o arquivo
nHandle := FCREATE(cArquivo) 
cData   := FWTimeStamp(2)
cNomeRot := "Inicio da rotina - Banco"


//FWRITE( nHandle, cData + CRLF)
//FWRITE( nHandle, cNomeRot + CRLF)
//FWRITE(nHandle, "Nenhum registro alterado"  + CRLF)
//FWRITE( nHandle, "Fim da Rotina" + CRLF)

FCLOSE(nHandle)

    //----- abrindo arquivo

nHandle := FOPEN(cArquivo,FO_READWRITE + FO_EXCLUSIVE)

    If nHandle == -1
        MSGALERT("Falha ao abrir ["+cArquivo+"]","Ferror " + cValToChar(fError()) )
            Return
    Endif

    FWRITE( nHandle, cData + CRLF)
    FWRITE( nHandle, cNomeRot + CRLF)
    FWRITE(nHandle, "Nenhum registro alterado"  + CRLF)
    FWRITE( nHandle, "Fim da Rotina" + CRLF)
    
    cNewLine:= REPLICATE('-', 25)
    FWRITE( nHandle, cNewLine + CRLF )

    nCliente:= '000001'
        FWRITE( nHandle, cData + CRLF)
        FWRITE( nHandle, cNomeRot + CRLF)
        FWRITE(nHandle, "Cliente " +  nCliente + " alterado " + CRLF)
        FWRITE( nHandle, "Fim da Rotina" + CRLF)  
    
        FWRITE( nHandle, cNewLine + CRLF )

    nCliente:= '000002'
        FWRITE( nHandle, cData + CRLF)
        FWRITE( nHandle, cNomeRot + CRLF)
        FWRITE(nHandle, "Cliente " +  nCliente + " alterado " + CRLF)
        FWRITE( nHandle, "Fim da Rotina" + CRLF)  
    
        FWRITE( nHandle, cNewLine + CRLF )

    nCliente:= '000003'
        FWRITE( nHandle, cData + CRLF)
        FWRITE( nHandle, cNomeRot + CRLF)
        FWRITE(nHandle, "Cliente " +  nCliente + " alterado " + CRLF)
        FWRITE( nHandle, "Fim da Rotina" + CRLF) 
        
        FWRITE( nHandle, cNewLine + CRLF )
    
    nCliente:= '000004'
        FWRITE( nHandle, cData + CRLF)
        FWRITE( nHandle, cNomeRot + CRLF)
        FWRITE(nHandle, "Cliente " +  nCliente + " alterado " + CRLF)
        FWRITE( nHandle, "Fim da Rotina" + CRLF)   

 
// Identifica o tamanho do arquivo 
nTamFile := fSeek(nHandle,0,FS_END)
fSeek(nHandle,0,FS_SET)
conout("Tamanho do Arquivo = "+cValToChaR(nTamFile)+" byte(s)." )

// Lê a primeira linha do arquivo 
cBuffer := ""
nRead := FRead( nHandle, @cBuffer, 40 )
conout("Byte(s) lido(s) : "+cValToChar(nRead))


    If nRead < 40
         MsgStop("Falha na leitura da primeira linha.","Ferror "+cValToChar(ferror()))
            Return
    Endif

    

//---- VERIFICANDO CLIENTES-------//


/*
    IF AtualizaBanco() == .T.
        FWRITE( nHandle, cData + CRLF)
        FWRITE( nHandle, cNomeRot + CRLF)
        FWRITE(nHandle, "Nenhum registro alterado"  + CRLF)

    else 
        FWRITE( nHandle, cData + CRLF)
        FWRITE( nHandle, cNomeRot + CRLF)   
        FWRITE(nHandle, SA1->A1_COD + CRLF) 

    ENDIF
    FCLOSE(nHandle)
*/
RETURN


do while condition
    
end
