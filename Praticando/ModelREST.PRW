#Include "Protheus.ch"
#Include "Restful.ch"

/*
ATIVIDADE 
Desenvolver um WebService com CRUD para vinhos na SZ0 
Get Ex: localhost:8400/rest/VINHOS?cVinhos=Tierruca // requisi��o usada no POSTMAN
    Passar o nome de um vinho - Definir uma vari�vel que receber� o par�metro modelo
    Buscar na SZ0 o nome de um vinho no ID
        Retornar: {"Vinho": false, // True - Se o vinho existir / False - Se n�o encontrar o tipo de vinho
                  "Modelo": "PESQUISADO"} // Retorna o nome do vinho pesquisado                 

Post Ex: localhost:8400/rest/........
     Body: {"Modelo": "Tierruca"}
    Pesquisa na SZ0 se existe o modelo e se n�o existe deve ser criado
        {"Vinho": True // Quando j� existe ou tu criou o vinho
        "Modelo": "PESQUISADO"
           
PUT Ex: localhost:8400/rest/........
        Body: {"Modelo": "Tierruca",
               "novo_Modelo": "Sangue de boi"
                }        
                Pesquisar na SZ0 o modelo e alterar ele para o novo modelo
                Se n�o existe ser� retornado
                {"vinho": false,
                "modelo": "Tierruca"}
                Se der certo
                {"vinho": true,
                "modelo": "Sangue de boi"}

 DELETE Ex: localhost:8400/rest/VINHOS?cVinho=Cancao
    Passar o nome de um vinho
    Buscar na SZ0 esse nome e deletar o registro com D_E_L_E_T_ e R_E_C_D_E_L_ e n�o do banco de dados
    Retorno deve ser
        {"vinho": false,
         "modelo": "Sangue de boi"}
   

U_FELSZ0( "NOME DO VINHO",;     // Campos Chave
        "NOME DO REST"   ,;     // Rotina executada
        Date()              ,;     // Data da execucao
        Time()              ,;     // Hora da execucao
        M�todo + resultado        ,;   // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
        cMsgRes        ,;   // Mensagem detalhada / S� ser� preenchida se houver falha / Se n�o encontrar um registro para fazzer o GET
        "POST"         ,;   // Tipo de operacao / M�todo realizado
        "2"            ,;   // Tipo de ocorrencia (1 = OK, 2 = Erro)
        cBody          )    // Estrutura Json enviada na requisicao    

*/

// #########################################################################################
// -------------------------------------------------------------------------------------- ##
// Fonte: exemplo_REST.PRW                                                                ##
// Tipo......: ( ) Classe  ( ) Gatilho  ( ) Ponto de Entrada (x) Fun��o                   ##
// -------------------------------------------------------------------------------------- ##
// Autor.....: Guilherme Barrios - Sosys Business Insight                                 ##
// Data......: 20/10/2023                                                                 ##
// Objetivo..: API para CRUD de vinhos na tabela SZ0                                      ##
//                                                                                        ##
// ---------------------------------------------------------------------------------------##
// Referencias..: https://tdn.totvs.com/pages/releaseview.action?pageId=75269436          ##
//                https://jsonformatter.curiousconcept.com/#                              ##
//      https://terminaldeinformacao.com/2017/12/12/qual-e-diferenca-entre-type-valtype/  ##
//                                                                                        ##
// #########################################################################################

WSRESTFUL VINHOS DESCRIPTION 'MEUS VINHOS'
    WSDATA cVinho AS STRING

    WSMETHOD GET    DESCRIPTION "Consulta do vinho" WSSYNTAX "cVinho"// Devolver se um modelo de vinho j� existe na tabela SA1
    WSMETHOD POST   DESCRIPTION '' // Criar um modelo de vinho
    WSMETHOD PUT    DESCRIPTION '' // Altero o nome do modelo do vinho
    WSMETHOD DELETE DESCRIPTION '' // Dele��o do registro do modelo do vinho
 
END WSRESTFUL

WSMETHOD GET WSRECEIVE cVinho WSSERVICE VINHOS
    Local oJson := JsonObject():new() // Inicia o objeto json

    ::SetContentType("application/json") // Seta o conte�do de retorno Json

    // Validar se o par�metro foi passado
    if ValType(self:cVinho) == 'U' .OR. Empty(self:cVinho)
        SetRestFault(400, 'Parametro vazio ou nulo')
        Return .F.
    endif


    // Conectar na tabela e buscar por um vinho
    DBSELECTAREA("SZ0")
    DbSetOrder(1) // Z0_FILIAL + Z0_ID
    conout((xFilial("SZ0") + self:cVinho))
    if DbSeek(xFilial("SZ0") + self:cVinho) // ::cVinho // Validar se existe a cvinho // self:cVinho substitui o Z0_ID
        // Retornar que ele existe com true
        // {"Vinho": false,
        // "modelo": "PESQUISADO"}
        // Criando o json. Passando o objeto json e entre colchetes usamos uma string para determinar a chave do json que recebe o conte�do do valor passado
        oJson['vinho']  := .T.
        // OJ  Chave        Valor
        oJson['modelo'] := self:cVinho
    else
        oJson['vinho']  := .F.
        oJson['modelo'] := self:cVinho
    endif
    self:SetResponse(oJson:toJson()) // ToJson converter um objeto json para o texto json

    //SZ0->(DbCLoseArea())
   
Return .T.

WSMETHOD POST WSSERVICE VINHOS
    Local cBody := FwNoAccent(DecodeUTF8(::GetContent())) // Recebe o conte�do passado no body(json) da requisi��o //FwNoAccent(DecodeUTF8) tira os acentos 
    Local oJson := JsonObject():new()
    Local cRetorno := oJson:FromJson(cBody) // Converte um texto json em um objeto json

    ::SetContentType("application/json") // Seta o conte�do de retorno Json

    If ValType(cRetorno) == 'C' // Valida tipo de vari�vel
        SetRestFault( 400, "Nao foi possivel processar a estrutura JSON." )
        Return .F.
    endif

    // Valida��o se existe a propriedade no objeto json
    if !(oJson:hasProperty('vinho') .AND. oJson:hasProperty('modelo'))
        SetRestFault( 400, "Faltou o parametro vinho ou modelo." )
        Return .F.
    endif

    // Valida��o do tipo da vari�vel
    if ValType(oJson['vinho'] ) <> "L"
        SetRestFault( 400, "O campo vinho deve ser logico." )
        Return .F.
    endif

    if ValType(oJson['modelo']) <> "C"
        SetRestFault( 400, "O campo modelo deve ser caractere." )
        Return .F.
    endif

    // Conectar na tabela e buscar por um vinho
    DBSELECTAREA('SZ0')
    DbSetOrder(1) // Z0_FILIAL + Z0_ID
    if DbSeek(xFilial('SZ0') + oJson['modelo'])
        ::SetResponse('{')
        ::SetResponse('"vinho": true,')
        ::SetResponse('"modelo": "' + oJson['modelo'] + '"')
        ::SetResponse('}')
    else
        // Cadastrar o vinho na tabela
        RecLock('SZ0', .T.)
            SZ0->Z0_ID := oJson['modelo']
        MsUnlock()

        // Outra forma de montar um json
        ::SetResponse('{')
        ::SetResponse('"vinho": true,')
        ::SetResponse('"modelo": "' + oJson['modelo'] + '"')
        ::SetResponse('}')
    endif

Return .T.

 WSMETHOD PUT WSSERVICE VINHOS
    Local cBody := FwNoAccent(DecodeUTF8(::GetContent())) // Recebe o conte�do passado no body(json) da requisi��o //FwNoAccent(DecodeUTF8) tira os acentos 
    Local oJson := JsonObject():new()
    Local cRetorno := oJson:FromJson(cBody) // Converte um texto json em um objeto json

    ::SetContentType("application/json") // Seta o conte�do de retorno Json

    If ValType(cRetorno) == 'C' // Valida tipo de vari�vel
        SetRestFault( 400, "Nao foi possivel processar a estrutura JSON." )
        Return .F.
    endif

    // Valida��o se existe a propriedade no objeto json
    if !(oJson:hasProperty('modelo') .AND. oJson:hasProperty('novo_Modelo'))
        SetRestFault( 400, "Faltou o parametro modelo ou novo_Modelo." )
        Return .F.
    endif

    // Valida��o do tipo da vari�vel
    //if ValType(oJson['vinho'] ) <> "L"
    //    SetRestFault( 400, "O campo vinho deve ser logico." )
    //    Return .F.
    //endif

    if ValType(oJson['modelo']) <> "C"
        SetRestFault( 400, "O campo modelo deve ser caractere." )
        Return .F.
    endif

    if ValType(oJson['novo_Modelo']) <> "C"
        SetRestFault( 400, "O campo novo_Modelo deve ser caractere." )
        Return .F.
    endif

    // Conectar na tabela e buscar por um vinho
    DBSELECTAREA('SZ0')
    DbSetOrder(1) // Z0_FILIAL + Z0_ID
    if DbSeek(xFilial('SZ0') + oJson['modelo'])
        RecLock('SZ0', .F.)
            SZ0->Z0_ID := oJson['novo_Modelo']
        MsUnlock()
        ::SetResponse('{')
        ::SetResponse('"vinho": true,')
        ::SetResponse('"modelo": "' + oJson['novo_Modelo'] + '"')
        ::SetResponse('}')
    else
            
        ::SetResponse('{')
        ::SetResponse('"vinho": false,')
        ::SetResponse('"modelo": "' + oJson['modelo'] + '"')
        ::SetResponse('}')
    endif

Return .T.

WSMETHOD DELETE WSRECEIVE cVinho WSSERVICE VINHOS
Local oJson := JsonObject():new() // Inicia o objeto json

// Validar se o par�metro foi passado
    if ValType(self:cVinho) == 'U' .OR. Empty(self:cVinho)
        SetRestFault(400, 'Parametro vazio ou nulo')
        Return .F.
    endif

    // Conectar na tabela e buscar por um vinho
    DBSELECTAREA("SZ0")
    DbSetOrder(1) // Z0_FILIAL + Z0_ID
   
    if DbSeek(xFilial("SZ0") + self:cVinho) // ::cVinho // Validar se existe a cvinho // self:cVinho substitui o Z0_ID
        RecLock('SZ0', .F.)
            DbDelete()
        MsUnlock()
        oJson['vinho']  := .F.
        oJson['modelo'] := self:cVinho
        self:SetResponse(oJson:toJson())
        conout("Vinho excluido")
    
        
        else
             DELETED() 
            ::SetResponse('{')
            ::SetResponse('"Mensagem":"Ja excluido anteriormente"')
            ::SetResponse('}')  

            //else
              //   SetRestFault(400, "Erro")           
        
    endif

::SetContentType("application/json") // Seta o conte�do de retorno Json

Return .T.
