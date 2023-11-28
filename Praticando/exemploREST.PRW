#include "protheus.ch"
#include "restful.ch"
#Include 'FWMVCDEF.ch'


// #########################################################################################
// -------------------------------------------------------------------------------------- ##
// Fonte: exemploREST.PRW                                                              ##
// Tipo......: ( ) Classe  ( ) Gatilho  ( ) Ponto de Entrada (x) Função                   ##
// -------------------------------------------------------------------------------------- ##
// Autor.....: Guilherme Barrios - Sosys Business Insight                                 ##
// Data......: 10/06/2022                                                                 ##
// Objetivo..: API parabloqueio e liberação de pedidos de venda                           ##
//                                                                                        ##
// ---------------------------------------------------------------------------------------##
// Releases..: Criação do fonte	como WS Rest                                              ##
//                                                                                  	  ##
// #########################################################################################


WSRESTFUL VINHOS DESCRIPTION "MEUS VINHOS"
    WSDATA MODELOVINHO AS STRING 
	//WSDATA cNum    	   AS STRING


    WSMETHOD GET    DESCRIPTION "Consulta modelo de vinho"        WSSYNTAX ""  // receber nome do vinho
    WSMETHOD POST   DESCRIPTION "Inclusao de modelo de vinho"     WSSYNTAX ""
    WSMETHOD PUT    DESCRIPTION "Atualização do modelo de vinho"  WSSYNTAX ""
    WSMETHOD DELETE DESCRIPTION "Excluir um modelo de vinho"      WSSYNTAX ""

END WSRESTFUL


// -----------escrita do metodo GET
WSMETHOD GET WSRECEIVE MODELOVINHO WSSERVICE vinhos
Local cModelo   := Self:MODELOVINHO // SE REFERE AO PROPRIO METODO
Local cJson     := ""
Local aArea := GetArea()


//RpcSetEnv("99","01") - SÓ USO QUANDO PRECISO TROCAR DE EMPRESA

DbSelectArea("SZ0") // ABRO A TABELA
DBSETORDER(1)

If DBSEEK(SZ0->Z0_FILIAL + cModelo)    
        ::setResponse('[{"Vinho":true, "Modelo": }]')
        U_FELSZ0( ""  			            ,;  // Campos Chave
		      "GET"   			                ,;  // Rotina executada
              Date()              		        ,;  // Data da execucao
		      Time()              		        ,;  // Hora da execucao
              "GET NOK"                         ,;  // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
              "Modelo de vinho não encontrado"   	,;  // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
              "GET"         			        ,;  // Tipo de operacao / Método realizado
		      "2"            			        ,;  // Tipo de ocorrencia (1 = OK, 2 = Erro)
              "")      
     /* 			
    elseif (SZ0->Z0_ID == cModelo)
        ::setResponse('[{"Vinho":true, "Modelo": "Tierruca"}]')
        U_FELSZ0( "Tierruca"  			            ,;  // Campos Chave
		      "GET"   			                ,;  // Rotina executada
              Date()              		        ,;  // Data da execucao
		      Time()              		        ,;  // Hora da execucao
              "GET OK"                         ,;  // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
              "Modelo de vinho encontrado"   	,;  // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
              "GET"         			        ,;  // Tipo de operacao / Método realizado
		      "1"            			        ,;  // Tipo de ocorrencia (1 = OK, 2 = Erro)
              "")  */
    ENDIF



SZ0->(DbCLoseArea())

::SetResponse(cJson)

RestArea(aArea)

//RpcClearEnv() 

RETURN .T.

// ------escrita do metodo POST
WSMETHOD POST  WSSERVICE vinhos
Local cJson     := ""
Local aArea := GetArea()

//RpcSetEnv("99","01")

DbSelectArea("SZ0") // ABRO A TABELA
DBSETORDER(1)

    If DBSEEK(SZ0->Z0_FILIAL + SZ0->Z0_ID) // SE ECONTRAR OS INDICES
        RECLOCK("SZ0", .F. )
            SZ0->Z0_ID:= "Tierruca"           
            U_FELSZ0( "Tierruca"  			            ,;  // Campos Chave
		              "POST"   			                ,;  // Rotina executada
                      Date()              		        ,;  // Data da execucao
		              Time()              		        ,;  // Hora da execucao
                      "POST OK"                         ,;  // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
                      "Modelo de vinho atualizado"   	,;  // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
                      "POST"         			        ,;  // Tipo de operacao / Método realizado
		              "1"            			        ,;  // Tipo de ocorrencia (1 = OK, 2 = Erro)
                      "")    					// Estrutura Json enviada na requisicao 

            ::setResponse('[{"Vinho":true, "Modelo": "Tierruca"}]') //  
        MSUNLOCK()

    else  // se não     
        U_FELSZ0(  ""  			            ,;  // Campos Chave
	               "POST"   			                ,;  // Rotina executada
                   Date()              		        ,;  // Data da execucao
	               Time()              		        ,;  // Hora da execucao
                   "POST sem vinho"                         ,;  // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
                   "Vinho não Encontrado"   	,;  // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
                   "POST"         			        ,;  // Tipo de operacao / Método realizado
	               "2"            			        ,;  // Tipo de ocorrencia (1 = OK, 2 = Erro)
                   "")    					// Estrutura Json enviada na requisicao 
        ::setResponse('[{"Vinho":false, "Modelo": "Nao encontrado"}]') //      
    EndIf

SZ0->(DbCLoseArea())

::SetResponse(cJson)

RestArea(aArea)

//RpcClearEnv() 


Return .T.


// ------escrita do metodo PUT --- Atualizar o nome do modelo do vinho
WSMETHOD PUT WSSERVICE vinhos
Local cJson     := ""
//Local aArea := GetArea()



//RpcSetEnv("99","01")

DbSelectArea("SZ0") // ABRO A TABELA
DBSETORDER(1)

If DBSEEK(SZ0->Z0_FILIAL + SZ0->Z0_ID) // SE ECONTRAR OS INDICES
        RECLOCK("SZ0", .F. )
            SZ0->Z0_ID:= "Sangue de Boi"           
            U_FELSZ0( "Sangue de Boi"  			            ,;  // Campos Chave
		              "PUT"   			                ,;  // Rotina executada
                      Date()              		        ,;  // Data da execucao
		              Time()              		        ,;  // Hora da execucao
                      "PUT OK"                         ,;  // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
                      "Modelo de vinho atualizado"   	,;  // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
                      "PUT"         			        ,;  // Tipo de operacao / Método realizado
		              "1"            			        ,;  // Tipo de ocorrencia (1 = OK, 2 = Erro)
                      "")    					// Estrutura Json enviada na requisicao 

            ::setResponse('[{"Vinho":true, "Novo_Modelo": "Sangue de Boi",}]') //  
        MSUNLOCK()

    else  // se não     
        U_FELSZ0(  "Tierruca"  			            ,;  // Campos Chave
	               "PUT"   			                ,;  // Rotina executada
                   Date()              		        ,;  // Data da execucao
	               Time()              		        ,;  // Hora da execucao
                   "PUT NOK"                         ,;  // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
                   "Sem alteração do vinho"   	,;  // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
                   "PUT"         			        ,;  // Tipo de operacao / Método realizado
	               "2"            			        ,;  // Tipo de ocorrencia (1 = OK, 2 = Erro)
                   "")    					// Estrutura Json enviada na requisicao 
        ::setResponse('[{"Vinho":false, "Modelo": "Tierruca"}]') //      
    EndIf




SZ0->(DbCLoseArea())

::SetResponse(cJson)

//RestArea(aArea)

RpcClearEnv() 


Return .T.
