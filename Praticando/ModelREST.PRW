#Include "Protheus.ch"
#Include "Restful.ch"

/*
ATIVIDADE 
Desenvolver um WebService com CRUD para vinhos na SZ0 
Get Ex: localhost:8400/rest/VINHOS?cVinhos=Tierruca // requisição usada no POSTMAN
    Passar o nome de um vinho - Definir uma variável que receberá o parâmetro modelo
    Buscar na SZ0 o nome de um vinho no ID
        Retornar: {"Vinho": false, // True - Se o vinho existir / False - Se não encontrar o tipo de vinho
                  "Modelo": "PESQUISADO"} // Retorna o nome do vinho pesquisado                 

Post Ex: localhost:8400/rest/........
     Body: {"Modelo": "Tierruca"}
    Pesquisa na SZ0 se existe o modelo e se não existe deve ser criado
        {"Vinho": True // Quando já existe ou tu criou o vinho
        "Modelo": "PESQUISADO"
           
PUT Ex: localhost:8400/rest/........
        Body: {"Modelo": "Tierruca",
               "novo_Modelo": "Sangue de boi"
                }        
                Pesquisar na SZ0 o modelo e alterar ele para o novo modelo
                Se não existe será retornado
                {"vinho": false,
                "modelo": "Tierruca"}
                Se der certo
                {"vinho": true,
                "modelo": "Sangue de boi"}

 DELETE Ex: localhost:8400/rest/VINHOS?cVinho=Cancao
    Passar o nome de um vinho
    Buscar na SZ0 esse nome e deletar o registro com D_E_L_E_T_ e R_E_C_D_E_L_ e não do banco de dados
    Retorno deve ser
        {"vinho": false,
         "modelo": "Sangue de boi"}
   

U_FELSZ0( "NOME DO VINHO",;     // Campos Chave
        "NOME DO REST"   ,;     // Rotina executada
        Date()              ,;     // Data da execucao
        Time()              ,;     // Hora da execucao
        Método + resultado        ,;   // Mensagem resumida - POST feito com sucesso / POST com erro / GET realizado com sucesso
        cMsgRes        ,;   // Mensagem detalhada / Só será preenchida se houver falha / Se não encontrar um registro para fazzer o GET
        "POST"         ,;   // Tipo de operacao / Método realizado
        "2"            ,;   // Tipo de ocorrencia (1 = OK, 2 = Erro)
        cBody          )    // Estrutura Json enviada na requisicao    

*/

// #########################################################################################
// -------------------------------------------------------------------------------------- ##
// Fonte: exemplo_REST.PRW                                                                ##
// Tipo......: ( ) Classe  ( ) Gatilho  ( ) Ponto de Entrada (x) Função                   ##
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

    WSMETHOD GET    DESCRIPTION "Consulta do vinho" WSSYNTAX "cVinho"// Devolver se um modelo de vinho já existe na tabela SA1
    WSMETHOD POST   DESCRIPTION '' // Criar um modelo de vinho
    WSMETHOD PUT    DESCRIPTION '' // Altero o nome do modelo do vinho
    WSMETHOD DELETE DESCRIPTION '' // Deleção do registro do modelo do vinho
 
END WSRESTFUL

WSMETHOD GET WSRECEIVE cVinho WSSERVICE VINHOS
    Local oJson := JsonObject():new() // Inicia o objeto json

    ::SetContentType("application/json") // Seta o conteúdo de retorno Json

    // Validar se o parâmetro foi passado
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
        // Criando o json. Passando o objeto json e entre colchetes usamos uma string para determinar a chave do json que recebe o conteúdo do valor passado
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
    Local cBody := FwNoAccent(DecodeUTF8(::GetContent())) // Recebe o conteúdo passado no body(json) da requisição //FwNoAccent(DecodeUTF8) tira os acentos 
    Local oJson := JsonObject():new()
    Local cRetorno := oJson:FromJson(cBody) // Converte um texto json em um objeto json

    ::SetContentType("application/json") // Seta o conteúdo de retorno Json

    If ValType(cRetorno) == 'C' // Valida tipo de variável
        SetRestFault( 400, "Nao foi possivel processar a estrutura JSON." )
        Return .F.
    endif

    // Validação se existe a propriedade no objeto json
    if !(oJson:hasProperty('vinho') .AND. oJson:hasProperty('modelo'))
        SetRestFault( 400, "Faltou o parametro vinho ou modelo." )
        Return .F.
    endif

    // Validação do tipo da variável
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
    Local cBody := FwNoAccent(DecodeUTF8(::GetContent())) // Recebe o conteúdo passado no body(json) da requisição //FwNoAccent(DecodeUTF8) tira os acentos 
    Local oJson := JsonObject():new()
    Local cRetorno := oJson:FromJson(cBody) // Converte um texto json em um objeto json

    ::SetContentType("application/json") // Seta o conteúdo de retorno Json

    If ValType(cRetorno) == 'C' // Valida tipo de variável
        SetRestFault( 400, "Nao foi possivel processar a estrutura JSON." )
        Return .F.
    endif

    // Validação se existe a propriedade no objeto json
    if !(oJson:hasProperty('modelo') .AND. oJson:hasProperty('novo_Modelo'))
        SetRestFault( 400, "Faltou o parametro modelo ou novo_Modelo." )
        Return .F.
    endif

    // Validação do tipo da variável
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

// Validar se o parâmetro foi passado
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

::SetContentType("application/json") // Seta o conteúdo de retorno Json

Return .T.
