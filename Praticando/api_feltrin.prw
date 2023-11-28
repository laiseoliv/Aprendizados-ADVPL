*******************************************************************************
*+-----------------------------------------------------------------------------+*
*|Fonte       | INCCLIENTE | Autor |    SOSYS  BUSINESS INSIGHT	               |*
*+------------+----------------------------------------------------------------+*
*|Data	      | 23/09/2021	                        		  				   |*
*+------------+----------------------------------------------------------------+*
*|Descricao   |    Método de inclusão de Clientes                  		       |*  
*|                                                                             |*
*+------------+----------------------------------------------------------------+*
*|Solicitante | FELTRIN                                                        |*
*+------------+----------------------------------------------------------------+*
*|Arquivos    |	                                                               |*
*+------------+----------------------------------------------------------------+*
*|	ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL   		                   |*
*+-----------------------------------------------------------------------------+*
*|	Criado validação para receber natureza									   |*
*|	Adicionado A1_ENDREC e A1_ENDCOB junto com o campo enderecoCob - Opcionais |*
*|	Campos opcionais adicionados                							   |*
*|	Mudança para JsonObject 									               |*
*|  Campo de banco criado                                                      |*
*+-----------------------------------------------------------------------------+*
*| Programador	     |	Data	   |		Funcao e Descricao                 |*
*+-------------------+-------------+-------------------------------------------+*
*| Eduardo Vasconcelos    | 06/09/2021  |                                      |*
*| Guilherme Barrios      | 27/01/2022  |                                      |*
*+-------------------+-------------+-------------------------------------------+*

// Exemplos de consultas 
/*------------GET(CONSULTA)--------------
EX:
http://localhost:8084/rest/INCCLIENTE?cFil=0101&cCod=000154

/*
--------POST(INCLUSAO)-------------
{
	"codigo":"123456",
	"nome": "GUILHERME BARRIOS", 
	"nomeReduz": "GUILHERME", 
	"cgc": "24139856033", 
	"tipo": "F", 
	"pessoa": "F", 
	"loja": "01",
	"natureza": "", 
	"endereco": "AV ASSIS BRASIL, 123", 
	"enderecoCob": "AV ASSIS BRASIL, 123",
	"complemento": "CASA 4",
	"pais": "105",
	"estado": "RS",
	"municipio": "14902",
	"bairro": "CRISTO REDENTOR",
	"cep": "91040640",
	"email": "guilherme.barrios@sosys.com.br",
	"telefoneResidencial": "555133999999",
	"telefoneCelular": "555199999999",
	"dataNascFund": "20220101",
	"inscricaoEst": "8103721741",
	"inscricaoMun": "",
	"rg": "193389769",
	"vendedor1": "2",
	"vendedor2": "",
	"grupoTrib": "001",
	"transportadora": "000682" // A1_TRANSP - PESQUISAR O CAMPO. RETORNAR NO GET - POST ADICIONAR O CAMPO, E NO PUT
}
*/

#Include "Protheus.ch"
#Include "Restful.ch"
#Include "Totvs.ch"
#INCLUDE "RWMAKE.CH" 
#include "tbiconn.ch"

WSRESTFUL INCCLIENTE DESCRIPTION "Inclusao de Cliente"
	WSDATA cCod AS STRING

    WSMETHOD GET    DESCRIPTION "Consulta de Clientes" WSSYNTAX "cCod"
	WSMETHOD POST   DESCRIPTION "Inclusao de Clientes" WSSYNTAX ""
	WSMETHOD PUT    DESCRIPTION "Inclusao de Clientes" WSSYNTAX ""
	WSMETHOD DELETE DESCRIPTION "Inclusao de Clientes" WSSYNTAX ""

END WSRESTFUL

WSMETHOD GET WSRECEIVE cCod WSSERVICE INCCLIENTE

	Local cCod   := ''  // Recebe os tratamentos para esse campo
	Local aLojas := {}  // Recebe os tratamentos para esse campo
    Local lOk    := .T. // Validações gerais 

    // Variáveis do Log
	Local cMsgRestFault := ""
	Local cMsgRes       := ""
	Local cMsgDetal     := ""

    // Objeto Json 
    Local jGetJson := JsonObject():New() // Monta o json de retorno Cabeçalho do PV (SC5) + itens do PV (SC6)
   
    ::SetContentType("application/json") // Seta o conteúdo de retorno Json

    // Valida os campos obrigatórios Filial e Número do PV
    if ValType( ::cCod ) == "U" .Or. Empty( ::cCod )
        cMsgRestFault := "Campo cCod esta vazio ou nao existe."
        cMsgRes       := "Campo cCod nao recebido."
        cMsgDetal     := "Campo cCod esta vazio ou nao existe."
        lOk := .F. 
	else // Trata o campo
        cCod := PadL(::cCod,TAMSX3("A1_COD")[1],'0')
    endif 

    if lOk 
        dbSelectArea("SA1") // Busca as lojas do cliente
        dbSetOrder(1) // A1_FILIAL + A1_COD + A1_LOJA
        if dbSeek( xFilial('SA1') + cCod )
            While SA1->( !Eof() ) .And. cCod == SA1->A1_COD
                Aadd(aLojas,JsonObject():new())
                aLojas[Val(SA1->A1_LOJA)]['codigo']              := AllTrim(SA1->A1_COD    )
                aLojas[Val(SA1->A1_LOJA)]['nome']                := AllTrim(SA1->A1_NOME   )
				aLojas[Val(SA1->A1_LOJA)]['nomeReduz']           := AllTrim(SA1->A1_NREDUZ )
				aLojas[Val(SA1->A1_LOJA)]['cgc']                 := AllTrim(SA1->A1_CGC    )
				aLojas[Val(SA1->A1_LOJA)]['tipo']                := AllTrim(SA1->A1_TIPO   )
				aLojas[Val(SA1->A1_LOJA)]['pessoa']              := AllTrim(SA1->A1_PESSOA )
				aLojas[Val(SA1->A1_LOJA)]['loja']                := AllTrim(SA1->A1_LOJA   )
				aLojas[Val(SA1->A1_LOJA)]['natureza']            := AllTrim(SA1->A1_NATUREZ)
				aLojas[Val(SA1->A1_LOJA)]['endereco']            := AllTrim(SA1->A1_END    )
				aLojas[Val(SA1->A1_LOJA)]['enderecoCob']         := AllTrim(SA1->A1_ENDCOB )
				aLojas[Val(SA1->A1_LOJA)]['complemento']         := AllTrim(SA1->A1_COMPLEM)
				aLojas[Val(SA1->A1_LOJA)]['pais']                := AllTrim(SA1->A1_PAIS   )
				aLojas[Val(SA1->A1_LOJA)]['estado']              := AllTrim(SA1->A1_EST    )
				aLojas[Val(SA1->A1_LOJA)]['municipio']           := AllTrim(SA1->A1_MUN    )
				aLojas[Val(SA1->A1_LOJA)]['bairro']              := AllTrim(SA1->A1_BAIRRO )
				aLojas[Val(SA1->A1_LOJA)]['cep']                 := AllTrim(SA1->A1_CEP    )
				aLojas[Val(SA1->A1_LOJA)]['email']               := AllTrim(SA1->A1_EMAIL  )
				aLojas[Val(SA1->A1_LOJA)]['telefoneResidencial'] := AllTrim(SA1->A1_TEL    )
				aLojas[Val(SA1->A1_LOJA)]['telefoneCelular']     := AllTrim(SA1->A1_CEL    )
				aLojas[Val(SA1->A1_LOJA)]['dataNascFund']        := AllTrim(SA1->A1_DTNASC )
				aLojas[Val(SA1->A1_LOJA)]['inscricaoEst']        := AllTrim(SA1->A1_INSCR  )
				aLojas[Val(SA1->A1_LOJA)]['inscricaoMun']        := AllTrim(SA1->A1_INSCRM )
				aLojas[Val(SA1->A1_LOJA)]['rg']                  := AllTrim(SA1->A1_RG     )
				aLojas[Val(SA1->A1_LOJA)]['vendedor1']           := AllTrim(SA1->A1_VEND   )
				aLojas[Val(SA1->A1_LOJA)]['vendedor2']           := AllTrim(SA1->A1_VEND2  )
				aLojas[Val(SA1->A1_LOJA)]['banco']               := AllTrim(SA1->A1_BCO1   )
				aLojas[Val(SA1->A1_LOJA)]['suframa']             := AllTrim(SA1->A1_SUFRAMA)
				aLojas[Val(SA1->A1_LOJA)]['grupoTrib']           := AllTrim(SA1->A1_GRPTRIB)
				aLojas[Val(SA1->A1_LOJA)]['transportadora']      := AllTrim(SA1->A1_TRANSP)
                SA1->( dbSkip() )
            enddo 
                
			// Monta o Json de retorno com o cliente e suas lojas 
        	jGetJson['lojas']:= aLojas      
        	jGetJson['idCliente'] := AllTrim(cCod)

            cMsgRes       := "Cliente retornado com sucesso."
            cMsgDetal     := "Cliente retornado com sucesso. " + cCod
            ::SetResponse(jGetJson:toJson())
            
			U_FELSZ0( cCod            ,; // Campos Chave
		              "INCCLIENTE"    ,; // Rotina executada
		              Date()          ,; // Data da execucao
		              Time()          ,; // Hora da execucao
		              cMsgRes         ,; // Mensagem resumida
		              cMsgDetal       ,; // Mensagem detalhada
		              "GET"           ,; // Tipo de operacao
		              "2"             ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
		              jGetJson:toJson()) // Estrutura Json enviada na requisicao
                
        else 
            cMsgRestFault := "Chave Get nao encontrada. " + cCod
            cMsgRes       := "Chave Get nao encontrada."
            cMsgDetal     := "Chave Get nao encontrada. " + cCod
            SetRestFault( 4, cMsgRestFault )
			lOk:= .F.

			U_FELSZ0( cCod            ,; // Campos Chave
		              "INCCLIENTE"    ,; // Rotina executada
		              Date()          ,; // Data da execucao
		              Time()          ,; // Hora da execucao
		              cMsgRes         ,; // Mensagem resumida
		              cMsgDetal       ,; // Mensagem detalhada
		              "GET"           ,; // Tipo de operacao
		              "2"             ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
		              jGetJson:toJson()) // Estrutura Json enviada na requisicao
        endif
    else 
        SetRestFault( 4, cMsgRestFault )
        U_FELSZ0( ''              ,; // Campos Chave
		          "INCCLIENTE"    ,; // Rotina executada
		          Date()          ,; // Data da execucao
		          Time()          ,; // Hora da execucao
		          cMsgRes         ,; // Mensagem resumida
		          cMsgDetal       ,; // Mensagem detalhada
		          "GET"           ,; // Tipo de operacao
		          "2"             ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
		          '')                // Estrutura Json enviada na requisicao
    endif 
	FreeObj(jGetJson)
Return lOk

WSMETHOD POST WSSERVICE INCCLIENTE

	Local lDeuCerto           := .F.
	Local aErro               := {}
	Local lOk                 := .T.
	Local cCodMun             := ""
    
	// Variáveis do Objeto Json 
	Local cBody               := FwNoAccent(DecodeUTF8(::GetContent()))
    Local jJson               := JsonObject():New()
	Local cRet                := ""
	
	// Campos
	Local cNaturez             := ""
	Local cEmail               := ""
	Local cTelefoneResidencial := ""
	Local cTelefoneCelular     := ""
	Local dDataNascFund        := ""
	Local cInscricaoEst        := ""
	Local cRG                  := ""
	Local cInscricaoMun        := ""
	Local cVendedor2           := ""
	Local cEnderecoCob         := ""
	Local cComplemento         := ""
	Local cCodigo              := ""
	Local cBanco               := ""
	Local cSuframa             := ""
	Local cConta               := ""
	Local cTransport		   := ""

	// Variáveis do Log
	Local cMsgRestFault        := ""
	Local cMsgRes              := ""
	Local cMsgDetal            := ""

	//PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilAnt TABLES 'SM2,SE1' MODULO 'FIN'

	::SetContentType("application/json")
	ConOut("EXECUTANDO POST INCCLIENTE")
	ConOut( cBody )

  	cRet := jJson:FromJson(cBody)

	If ValType(cRet) == 'C'
		cMsgRestFault := "Nao foi possivel processar a estrutura Json." 
		cMsgDetal     := "Nao foi possivel processar a estrutura Json."
		cMsgRes       := "Nao foi possivel processar a estrutura Json."
		lOk           := .F. 
    Else 		
		// Validação do nome
		If jJson:hasProperty('nome') .AND. ValType(jJson['nome']) == 'C'
			If Empty(jJson['nome'])
				cMsgRestFault := "O valor do campo nome esta vazio." 
				cMsgDetal     := "O valor do campo nome esta vazio."
				cMsgRes       := "Campo nome vazio"
				lOk           := .F. 
			EndIf
		Else 
			cMsgRestFault := "O campo nome nao existe." 
			cMsgDetal     := "O campo nome nao existe"
			cMsgRes       := "nome nulo"
			lOk           := .F.
		Endif

		// Valida o nome reduzido 
		If jJson:hasProperty('nomeReduz') .AND. ValType(jJson['nomeReduz']) == 'C'
			If Empty(jJson['nomeReduz'])
				cMsgRestFault := "O valor do campo nomeReduz esta vazio." 
				cMsgDetal     := "O valor do campo nomeReduz esta vazio."
				cMsgRes       := "Campo nomeReduz vazio"
				lOk           := .F. 
			EndIf
		Else 
			cMsgRestFault := "O campo nomeReduz nao existe." 
			cMsgDetal     := "O campo nomeReduz nao existe"
			cMsgRes       := "nomeReduz nulo"
			lOk           := .F.
		Endif
		
		// Validação de Pessoa Físicia ou Jurídica
		If jJson:hasProperty('tipo') .AND. ValType(jJson['tipo']) == 'C'
			If Empty(jJson['tipo'])
				cMsgRestFault := "O valor do campo tipo esta vazio." 
				cMsgDetal     := "O valor do campo tipo esta vazio."
				cMsgRes       := "Campo tipo vazio"
				lOk           := .F. 
			Else  
				If !AllTrim( jJson['tipo'] ) $ "FXLRS"
					cMsgRes       := "Codigo do campo tipo esta invalido."
					cMsgRestFault := "Codigo tipo incorreto. Deve ser F, X, L, R ou S."
					cMsgDetal     := "Codigo do campo tipo esta invalido."
					lOk           := .F.
				endif
			EndIf 
		Else 
			cMsgRestFault := "O campo tipo nao existe." 
			cMsgDetal     := "O campo tipo nao existe"
			cMsgRes       := "tipo nulo"
			lOk           := .F.
		EndIf 

		// Validação de Pessoa Físicia ou Jurídica
		If jJson:hasProperty('pessoa') .AND. ValType(jJson['pessoa']) == 'C'
			If Empty(jJson['pessoa'])
				cMsgRestFault := "O valor do campo pessoa esta vazio." 
				cMsgDetal     := "O valor do campo pessoa esta vazio."
				cMsgRes       := "Campo pessoa vazio"
				lOk           := .F. 
			Else  
				If !AllTrim( jJson['pessoa'] ) $ "FJX"
					cMsgRes       := "Codigo do campo pessoa esta invalido."
					cMsgRestFault := "Tipo de pessoa incorreto. Deve ser F, J ou X."
					cMsgDetal     := "Codigo do campo pessoa esta invalido."
					lOk           := .F.
				endif
			EndIf 
		Else 
			cMsgRestFault := "O campo pessoa nao existe." 
			cMsgDetal     := "O campo pessoa nao existe"
			cMsgRes       := "pessoa nulo"
			lOk           := .F.
		EndIf 

		// Valida CPF/CNPJ
		If jJson:hasProperty('cgc') .AND. ValType(jJson['cgc']) == 'C'
			If Empty(jJson['cgc'])
				cMsgRestFault := "O valor do campo cgc esta vazio." 
				cMsgDetal     := "O valor do campo cgc esta vazio."
				cMsgRes       := "Campo cgc vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo cgc nao existe." 
			cMsgDetal     := "O campo cgc nao existe"
			cMsgRes       := "cgc nulo"
			lOk           := .F.
		EndIf 

		// Valida o Grupo Tributário
		If jJson:hasProperty('grupoTrib') .AND. ValType(jJson['grupoTrib']) == 'C'
			If Empty(jJson['grupoTrib'])
				cMsgRestFault := "O valor do campo grupoTrib esta vazio." 
				cMsgDetal     := "O valor do campo grupoTrib esta vazio."
				cMsgRes       := "Campo grupoTrib vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo grupoTrib nao existe." 
			cMsgDetal     := "O campo grupoTrib nao existe"
			cMsgRes       := "grupoTrib nulo"
			lOk           := .F.
		EndIf 

		// Valida o CPF/CNPJ com o tipo de pessoa
		If (len(jJson['cgc']) <> 11 .and. (jJson['pessoa']) == "F")
			cMsgRestFault := "Tamanho invalido de numero identificacao - tipo CPF." 
			cMsgDetal     := "Tamanho invalido de numero identificacao - tipo CPF."
			cMsgRes       := "Numero identificacao tamanho nao permitido - CPF"
			lOk           := .F.
		Elseif (len(jJson['cgc']) <> 14 .and. (jJson['pessoa']) == "J")
			cMsgRestFault := "Tamanho invalido de numero identificacao - tipo CNPJ." 
			cMsgDetal     := "Tamanho invalido de numero identificacao - tipo CNPJ."
			cMsgRes       := "Numero identificacao tamanho nao permitido - CNPJ"
			lOk           := .F.
		Endif

		// Valida se o CGC já foi cadastrado 
		dbSelectArea("SA1")
		dbSetOrder(3) // A1_FILIAL + A1_CGC
		If dbSeek( xFilial("SA1") + jJson['cgc'] )
			cMsgRestFault := "Cliente " + SA1->A1_COD + " ja cadastrado com esse cgc." 
			cMsgDetal     := "Cliente " + SA1->A1_COD + " ja cadastrado com esse cgc."
			cMsgRes       := "Cliente ja cadastrado"
			lOk           := .F.
		endif 

		// Valida o Estado
		If jJson:hasProperty('estado') .AND. ValType(jJson['estado']) == 'C'
			If Empty(jJson['estado'])
				cMsgRestFault := "O valor do campo estado esta vazio." 
				cMsgDetal     := "O valor do campo estado esta vazio."
				cMsgRes       := "Campo estado vazio"
				lOk           := .F.
			Else 
				dbSelectArea("SX5")
				dbSetOrder(1) // X5_TABELA+X5_CHAVE
				If !dbSeek( xFilial("SX5") + "12" + jJson['estado'] )
					cMsgRes       := "Codigo do estado do cliente esta invalido."
					cMsgRestFault := "O Codigo do estado informado esta invalido." 
					cMsgDetal     := "Codigo do estado do cliente esta invalido."
					lOk           := .F.	
				else 
					// Valida a Natureza - Opcional
					If jJson:hasProperty('natureza') .AND. ValType(jJson['natureza']) == 'C'
						If !Empty(jJson['natureza'])
							dbSelectArea("SED")
        			    	dbSetOrder(1) // ED_FILIAL + ED_CODIGO
        			    	If !dbSeek(xFilial("SED") + jJson['natureza'])
								cMsgRes       := "O Codigo da natureza nao consta no Protheus."
								cMsgRestFault := "O Codigo da natureza nao consta no Protheus." 
								cMsgDetal     := "O Codigo da natureza nao consta no Protheus."	
								lOk           := .F.
							Else 
								cNaturez := jJson['natureza']
							EndIf 
						Else 
							if AllTrim(jJson['estado']) <> 'EX'
								cNaturez := '4011110002'
							else 
								cNaturez := '4011110006'
							endif 
						EndIf 
					Else 
						if AllTrim(jJson['estado']) <> 'EX'
							cNaturez := '4011110002'
						else 
							cNaturez := '4011110006'
						endif 
					EndIf 
				endif
			EndIf 
		Else 
			cMsgRestFault := "O campo estado nao existe." 
			cMsgDetal     := "O campo estado nao existe"
			cMsgRes       := "estado nulo"
			lOk           := .F.
		EndIf 
		
		// Valida o município 
		If jJson:hasProperty('municipio') .AND. ValType(jJson['municipio']) == 'C'
			If Empty(jJson['municipio'])
				cMsgRestFault := "O valor do campo municipio esta vazio." 
				cMsgDetal     := "O valor do campo municipio esta vazio."
				cMsgRes       := "Campo municipio vazio"
				lOk           := .F.
			Else 
				dbSelectArea("CC2")
				dbSetOrder(1) // CC2_FILIAL+CC2_EST+CC2_CODMUN
				If !dbSeek( xFilial("CC2") + jJson['estado'] + jJson['municipio'] )
					cMsgRes       := "Codigo do municipio do cliente esta invalido."
					cMsgRestFault := "O Codigo do municipio informado esta invalido."
					cMsgDetal     := "Codigo do municipio do cliente esta invalido."
					lOk           := .F.					 			
				Else 
					cCodMun := CC2->CC2_CODMUN
				EndIf
			EndIf 
		Else 
			cMsgRestFault := "O campo municipio nao existe."
			cMsgRes       := "municipio nulo"
			cMsgDetal     := "O campo municipio nao existe"
			lOk           := .F.
		EndIf 
		
		// Validação do País
		If jJson:hasProperty('pais') .AND. ValType(jJson['pais']) == 'C'
			If Empty(jJson['pais'])
				cMsgRestFault := "O valor do campo pais esta vazio." 
				cMsgDetal     := "O valor do campo pais esta vazio."
				cMsgRes       := "Campo pais vazio"
				lOk           := .F.
			Else 
				dbSelectArea("SYA")
				dbSetOrder(1) // SYA_FILIAL + SYA_CODGI
				If !dbSeek( xFilial("SYA") + jJson['pais'] )
					cMsgRes       := "Codigo do pais do cliente esta invalido."
					cMsgRestFault := "O Codigo do pais informado esta invalido." 
					cMsgDetal     := "Codigo do pais do cliente esta invalido."
					lOk           := .F.					 			
				EndIf
			EndIf 
		Else 
			cMsgRestFault := "O campo pais nao existe." 
			cMsgDetal     := "O campo pais nao existe"
			cMsgRes       := "pais nulo"
			lOk           := .F.
		EndIf 

		// Valida o endereço
		If jJson:hasProperty('endereco') .AND. ValType(jJson['endereco']) == 'C'
			If Empty(jJson['endereco'])
				cMsgRestFault := "O valor do campo endereco esta vazio." 
				cMsgDetal     := "O valor do campo endereco esta vazio."
				cMsgRes       := "Campo endereco vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo endereco nao existe."
			cMsgRes       := "endereco nulo"
			cMsgDetal     := "O campo endereco nao existe"
			lOk           := .F.
		EndIf 

		// Valida Vendedor1
		If jJson:hasProperty('vendedor1') .AND. ValType(jJson['vendedor1']) == 'C'
			If !Empty(jJson['vendedor1'])
				dbSelectArea("SA3") 
            	dbSetOrder(1) // A3_FILIAL + A3_CODIGO
            	If !dbSeek(xFilial("SA3") + jJson['vendedor1'])
					cMsgRestFault := "O Codigo do vendedor1 nao consta no Protheus." 
					cMsgDetal     := "O Codigo do vendedor1 nao consta no Protheus."
					cMsgRes       := "Campo vendedor1 vazio"
					lOk           := .F.
				EndIf 
			Else 
				cMsgRestFault := "O valor do campo vendedor1 esta vazio." 
				cMsgDetal     := "O valor do campo vendedor1 esta vazio."
				cMsgRes       := "Campo vendedor1 vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo vendedor1 nao existe."
			cMsgRes       := "vendedor1 nulo"
			cMsgDetal     := "O campo vendedor1 nao existe"
			lOk           := .F.
		EndIf 

		// Valida Vendedor2 - OPCIONAL
		If jJson:hasProperty('vendedor2') .AND. ValType(jJson['vendedor2']) == 'C'
			If !Empty(jJson['vendedor2'])
				dbSelectArea("SA3")
            	dbSetOrder(1) // A3_FILIAL + A3_CODIGO
            	If !dbSeek(xFilial("SA3") + jJson['vendedor2'])
					cMsgRes       := "O Codigo do vendedor2 nao consta no Protheus.."
					cMsgRestFault := "O Codigo do vendedor2 nao consta no Protheus.." 
					cMsgDetal     := "O Codigo do vendedor2 nao consta no Protheus.."	
					lOk           := .F.
				Else 
					cVendedor2 := jJson['vendedor2']
				EndIf 
			EndIf 
		Else 
			cVendedor2 := ""
		EndIf 

		// Valida a Banco - Opcional
		If jJson:hasProperty('banco') .AND. ValType(jJson['banco']) == 'C'
			cBanco := jJson['banco']
		else 
			cBanco := '' // Código do banco padrão em caso de falta de banco no cadastro
		EndIf 

		// Valida a Banco - Opcional
		If jJson:hasProperty('suframa') .AND. ValType(jJson['suframa']) == 'C'
			cSuframa := jJson['suframa']
		else 
			cSuframa := '' // Código do banco padrão em caso de falta de banco no cadastro
		EndIf 

		//Valida email
		If jJson:hasProperty('email') .AND. ValType(jJson['email']) == 'C'
			cEmail := jJson['email']
		EndIf 

		// Seleciona a conta
		If jJson['estado'] == 'EX'
			cConta := '1010206010003'
		else 
			cConta := '1010206010002'
		EndIf 

		// Valida telefoneResidencial - OPCIONAL
		If jJson:hasProperty('telefoneResidencial') .AND. ValType(jJson['telefoneResidencial']) == 'C'
			cTelefoneResidencial := jJson['telefoneResidencial']
		EndIf 

		// Valida telefoneCelular - OPCIONAL
		If jJson:hasProperty('telefoneCelular') .AND. ValType(jJson['telefoneCelular']) == 'C'
			cTelefoneCelular := jJson['telefoneCelular']
		EndIf 

		// Valida complemento - OPCIONAL
		If jJson:hasProperty('complemento') .AND. ValType(jJson['complemento']) == 'C'
			cComplemento := jJson['complemento']
		EndIf 

		// Valida dataNascFund - OPCIONAL
		If jJson:hasProperty('dataNascFund') .AND. ValType(jJson['dataNascFund']) == 'C'
			dDataNascFund := StoD(jJson['dataNascFund'])
		EndIf 		

		// Valida inscricaoEst - OPCIONAL
		If jJson:hasProperty('inscricaoEst') .AND. ValType(jJson['inscricaoEst']) == 'C'
			cInscricaoEst := jJson['inscricaoEst']
		EndIf 

		// Valida inscricaoMun - OPCIONAL
		If jJson:hasProperty('inscricaoMun') .AND. ValType(jJson['inscricaoMun']) == 'C'
			cInscricaoMun := jJson['inscricaoMun']
		EndIf 

		// Valida rg - OPCIONAL
		If jJson:hasProperty('rg') .AND. ValType(jJson['rg']) == 'C'
			cRG := jJson['rg']
		EndIf 

		// Valida enderecoCob - OPCIONAL
		If jJson:hasProperty('enderecoCob') .AND. ValType(jJson['enderecoCob']) == 'C'
			cEnderecoCob := jJson['enderecoCob']
		EndIf 

		// Valida campo código - OPCIONAL
		If jJson:hasProperty('codigo') .AND. !Empty(jJson['codigo'])
			cCodigo := jJson['codigo']
		else 
			cCodigo := NextNumero("SA1",1,"A1_COD",.T.)
		EndIf
		
		//Valida campo TRANSPORTADORA - OPCIONAL	
		If jJson:hasProperty('transportadora') .AND. ValType(jJson['transportadora']) == 'C'
			If !Empty(jJson['transportadora'])
				dbSelectArea("SA4")
            	dbSetOrder(1) // A4_FILIAL + A4_COD
            	If !dbSeek(xFilial("SA4") + jJson['transportadora'])
					cMsgRes       := "O Codigo da tranportadora nao consta no Protheus.."
					cMsgRestFault := "O Codigo da tranportadora nao consta no Protheus.."
					cMsgDetal     := "O Codigo da tranportadora nao consta no Protheus.."	
					lOk           := .F.
				Else 
					cTransport := jJson['transportadora']
				EndIf 
			EndIf 
		Else 
			cTransport := ""
		EndIf 
		

		If lOk
			lDeuCerto := .F.
			
			// Pegando o modelo de dados, setando a operaÃ§Ã£o de inclusÃ£o
			oModel := FWLoadModel("MATA030")
			oModel:SetOperation(3)
			oModel:Activate()
			
			// Pegando o model dos campos da SA1
			oSA1Mod:= oModel:getModel("MATA030_SA1")
			oSA1Mod:setValue("A1_COD"    , cCodigo                        ) // Codigo 
			oSA1Mod:setValue("A1_LOJA"   , jJson['loja']                  ) // Loja
			oSA1Mod:setValue("A1_NOME"   , SubStr(jJson['nome'],0,40)     ) // Nome             
			oSA1Mod:setValue("A1_NREDUZ" , SubStr(jJson['nomeReduz'],0,20)) // Nome reduz. 
			oSA1Mod:setValue("A1_END"    , jJson['endereco']              ) // Endereco
			oSA1Mod:setValue("A1_ENDREC" , jJson['endereco']              ) // End. de Receb. do cliente
			oSA1Mod:setValue("A1_COMPLEM", cComplemento                   ) // End. de Complemento
			oSA1Mod:setValue("A1_BAIRRO" , jJson['bairro']                ) // Bairro
			oSA1Mod:setValue("A1_TIPO"   , jJson['tipo']                  ) // Tipo 
			oSA1Mod:setValue("A1_EST"    , jJson['estado']                ) // Estado                
			oSA1Mod:setValue("A1_MUN"    , jJson['municipio']             ) // Municipio
			oSA1Mod:setValue("A1_CEP"    , jJson['cep']                   ) // CEP
			oSA1Mod:setValue("A1_CGC"    , jJson['cgc']                   ) // CNPJ/CPF            
			oSA1Mod:setValue("A1_PAIS"   , jJson['pais']                  ) // Pais                       
			oSA1Mod:setValue("A1_PESSOA" , jJson['pessoa']                ) // Tipo Pessoa
			oSA1Mod:setValue("A1_VEND"   , jJson['vendedor1']             ) // Vendedor 1
			oSA1Mod:setValue("A1_GRPTRIB", jJson['grupoTrib']             ) // Limite de crédito padrão no cadastro
			oSA1Mod:setValue("A1_COD_MUN", cCodMun                        ) // Cod Municipio
			oSA1Mod:setValue("A1_NATUREZ", cNaturez                       ) // Natureza
			oSA1Mod:setValue("A1_EMAIL"  , cEmail                         ) // E-mail
			oSA1Mod:setValue("A1_TEL"    , cTelefoneResidencial           ) // Telefone Comercial
			oSA1Mod:setValue("A1_CEL"    , cTelefoneCelular               ) // Telefone Celular
			oSA1Mod:setValue("A1_DTNASC" , dDataNascFund                  ) // Data de nascimento/fundação
			oSA1Mod:setValue("A1_INSCR"  , cInscricaoEst                  ) // Inscrição estadual
			oSA1Mod:setValue("A1_RG"     , cRG                            ) // RG
			oSA1Mod:setValue("A1_INSCRM" , cInscricaoMun                  ) // Inscrição Municipal
			oSA1Mod:setValue("A1_VEND2"  , cVendedor2                     ) // Vendedor 2
			oSA1Mod:setValue("A1_ENDCOB" , cEnderecoCob                   ) // End.de cobr. do cliente
			oSA1Mod:setValue("A1_BCO1 "  , cBanco                         ) // Banco padrão do cliente
			oSA1Mod:setValue("A1_SUFRAMA", cSuframa                       ) // Código Suframa do cliente
			oSA1Mod:setValue("A1_CONTA"  , cConta                         ) // Conta Contábil
			oSA1Mod:setValue("A1_LC"     , 5000                           ) // Limite de crédito padrão no cadastro
			oSA1Mod:setValue("A1_TRANSP" , cTransport                     ) // Transportadora

			// Se conseguir validar as informacoes
			If oModel:VldData()
			
				// Tenta realizar o commit
				If oModel:CommitData()
					lDeuCerto := .T.
			
				// Se nao deu certo, altera a variavel para false
				Else
					lDeuCerto := .F.
				EndIf
			
			// Se nao conseguir validar as informaçoes, altera a variavel para false
			Else
				lDeuCerto := .F.
			EndIf
			
			// Se nao deu certo a inclusao, mostra a mensagem de erro
			If ! lDeuCerto
				//Busca o Erro do Modelo de Dados
				aErro := oModel:GetErrorMessage()
				cMsgRes       := "Erro de inclusão"
				cMsgDetal     := "Erro - " + StrTran(FwNoAccent(aErro[6]),chr(13)+chr(10),'')
				lOk := .F.

				::SetResponse('{')
				::SetResponse('"status": "2",')
				::SetResponse('"erroDetalhes": "'+"Erro - " + StrTran(FwNoAccent(aErro[6]),chr(13)+chr(10),'') + '"' )
				::SetResponse('}')

				U_FELSZ0( ''       ,; // Campos Chave
						  "CLIENTE",; // Rotina executada
						  Date()   ,; // Data da execucao
						  Time()   ,; // Hora da execucao
						  cMsgRes  ,; // Mensagem resumida
						  cMsgDetal,; // Mensagem detalhada
						  "POST"   ,; // Tipo de operacao
						  "2"      ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
						  cBody     ) // Estrutura Json enviada na requisicao	
			Else 
				cMsgRes       := SA1->A1_COD
				cMsgDetal     := "Incluido com sucesso."
				lOk := .T.
				
				::SetResponse('{')
				::SetResponse('"status": "1",')
				::SetResponse('"filial": "'+xFilial('SA1')+'",')
				::SetResponse('"idCliente": "' + SA1->A1_COD + '"' )
				::SetResponse('}')

				U_FELSZ0( SA1->A1_COD,; // Campos Chave
						  "CLIENTE"  ,; // Rotina executada
						  Date()     ,; // Data da execucao
						  Time()     ,; // Hora da execucao
						  cMsgRes    ,; // Mensagem resumida
						  cMsgDetal  ,; // Mensagem detalhada
						  "POST"     ,; // Tipo de operacao
						  "1"        ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
						  cBody       ) // Estrutura Json enviada na requisicao	
			Endif
			
			// Desativa o modelo de dados
			oModel:DeActivate()
		else
			SetRestFault( 4, cMsgRestFault )
			U_FELSZ0( ''       ,; // Campos Chave
					  "CLIENTE",; // Rotina executada
					  Date()   ,; // Data da execucao
					  Time()   ,; // Hora da execucao
					  cMsgRes  ,; // Mensagem resumida
					  cMsgDetal,; // Mensagem detalhada
					  "POST"   ,; // Tipo de operacao
					  "2"      ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
					  cBody     ) // Estrutura Json enviada na requisicao	
		endif
	EndIf 
	FreeObj(jJson)
Return lOk

WSMETHOD PUT WSSERVICE INCCLIENTE

	//Local lDeuCerto           := .F.
//	Local aErro               := {}
	Local lOk                 := .T.
	Local cCodMun             := ""
    //Local oModel

	// Variáveis do Objeto Json 
	Local cBody               := FwNoAccent(DecodeUTF8(::GetContent()))
    Local jJson               := JsonObject():New()
	Local cRet                := ""
	
	// Campos
	Local cNaturez             := ""
	Local cEmail               := ""
	Local cTelefoneResidencial := ""
	Local cTelefoneCelular     := ""
	Local dDataNascFund        := ""
	Local cInscricaoEst        := ""
	Local cRG                  := ""
	Local cInscricaoMun        := ""
	Local cVendedor2           := ""
	Local cVendedor1           := ""
	Local cEnderecoCob         := ""
	Local cComplemento         := ""
	Local cCodigo              := ""
	Local cBanco               := ""
	Local cSuframa             := ""
	Local cTransport		   := ""

	// Variáveis do Log
	Local cMsgRestFault        := ""
	Local cMsgRes              := ""
	Local cMsgDetal            := ""

	//ExecAuto (CRMA980)
	Local aSA1Auto 			:= {}
	Local aAI0Auto 			:= {}
	Local nOpcAuto 			  //MODEL_OPERATION_INSERT (3-Inclusão, 4-Alteração, 5-Exclusão)
	Local lRet     			:= .T.
	Local cErrorLog     	:= ""
	Private lMsErroAuto 	:= .F.  
	Private lMsHelpAuto     := .T. 
    private lAutoErrNoFile  := .T.
	
	

	::SetContentType("application/json")
	//ConOut("EXECUTANDO PUT INCCLIENTE")
	ConOut( cBody )

  	cRet := jJson:FromJson(cBody)

	If ValType(cRet) == 'C'
		cMsgRestFault := "Nao foi possivel processar a estrutura Json." 
		cMsgDetal     := "Nao foi possivel processar a estrutura Json."
		cMsgRes       := "Nao foi possivel processar a estrutura Json."
		lOk           := .F. 
    Else 
		// Valida o código do cliente
		If jJson:hasProperty('codigo') .AND. ValType(jJson['codigo']) == 'C'
			If !Empty(jJson['codigo'])
				dbSelectArea("SA1")
            	dbSetOrder(1) // A1_FILIAL+A1_COD+A1_LOJA
				If !dbSeek(xFilial("SA1") + jJson['codigo'])
					cMsgRestFault := "O valor do campo codigo cliente nao consta no Protheus." 
					cMsgDetal     := "O valor do campo codigo cliente nao consta no Protheus."
					cMsgRes       := "O valor do campo codigo cliente nao consta no Protheus"
					lOk           := .F.
				else 
					cCodigo := jJson['codigo']
				ENDIF
			EndIf 
		Else 
			cMsgRestFault := "O campo codigo nao existe." 
			cMsgDetal     := "O campo codigo nao existe"
			cMsgRes       := "codigo nulo"
			lOk           := .F.
		EndIf 

		// Validação do nome
		If jJson:hasProperty('nome') .AND. ValType(jJson['nome']) == 'C'
			If Empty(jJson['nome'])
				cMsgRestFault := "O valor do campo nome esta vazio." 
				cMsgDetal     := "O valor do campo nome esta vazio."
				cMsgRes       := "Campo nome vazio"
				lOk           := .F. 
			EndIf
		Else 
			cMsgRestFault := "O campo nome nao existe." 
			cMsgDetal     := "O campo nome nao existe"
			cMsgRes       := "nome nulo"
			lOk           := .F.
		Endif

		// Valida o nome reduzido 
		If jJson:hasProperty('nomeReduz') .AND. ValType(jJson['nomeReduz']) == 'C'
			If Empty(jJson['nomeReduz'])
				cMsgRestFault := "O valor do campo nomeReduz esta vazio." 
				cMsgDetal     := "O valor do campo nomeReduz esta vazio."
				cMsgRes       := "Campo nomeReduz vazio"
				lOk           := .F. 
			EndIf
		Else 
			cMsgRestFault := "O campo nomeReduz nao existe." 
			cMsgDetal     := "O campo nomeReduz nao existe"
			cMsgRes       := "nomeReduz nulo"
			lOk           := .F.
		Endif
		
		// Validação de Pessoa Físicia ou Jurídica
		If jJson:hasProperty('tipo') .AND. ValType(jJson['tipo']) == 'C'
			If Empty(jJson['tipo'])
				cMsgRestFault := "O valor do campo tipo esta vazio." 
				cMsgDetal     := "O valor do campo tipo esta vazio."
				cMsgRes       := "Campo tipo vazio"
				lOk           := .F. 
			Else  
				If !AllTrim( jJson['tipo'] ) $ "FXLRS"
					cMsgRes       := "Codigo do campo tipo esta invalido."
					cMsgRestFault := "Codigo tipo incorreto. Deve ser F, X, L, R ou S."
					cMsgDetal     := "Codigo do campo tipo esta invalido."
					lOk           := .F.
				endif
			EndIf 
		Else 
			cMsgRestFault := "O campo tipo nao existe." 
			cMsgDetal     := "O campo tipo nao existe"
			cMsgRes       := "tipo nulo"
			lOk           := .F.
		EndIf 

		// Validação de Pessoa Físicia ou Jurídica
		If jJson:hasProperty('pessoa') .AND. ValType(jJson['pessoa']) == 'C'
			If Empty(jJson['pessoa'])
				cMsgRestFault := "O valor do campo pessoa esta vazio." 
				cMsgDetal     := "O valor do campo pessoa esta vazio."
				cMsgRes       := "Campo pessoa vazio"
				lOk           := .F. 
			Else  
				If !AllTrim( jJson['pessoa'] ) $ "FJX"
					cMsgRes       := "Codigo do campo pessoa esta invalido."
					cMsgRestFault := "Tipo de pessoa incorreto. Deve ser F, J ou X."
					cMsgDetal     := "Codigo do campo pessoa esta invalido."
					lOk           := .F.
				endif
			EndIf 
		Else 
			cMsgRestFault := "O campo pessoa nao existe." 
			cMsgDetal     := "O campo pessoa nao existe"
			cMsgRes       := "pessoa nulo"
			lOk           := .F.
		EndIf 

		// Valida CPF/CNPJ
		If jJson:hasProperty('cgc') .AND. ValType(jJson['cgc']) == 'C'
			If Empty(jJson['cgc'])
				cMsgRestFault := "O valor do campo cgc esta vazio." 
				cMsgDetal     := "O valor do campo cgc esta vazio."
				cMsgRes       := "Campo cgc vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo cgc nao existe." 
			cMsgDetal     := "O campo cgc nao existe"
			cMsgRes       := "cgc nulo"
			lOk           := .F.
		EndIf 

		// Valida o Grupo Tributário
		If jJson:hasProperty('grupoTrib') .AND. ValType(jJson['grupoTrib']) == 'C'
			If Empty(jJson['grupoTrib'])
				cMsgRestFault := "O valor do campo grupoTrib esta vazio." 
				cMsgDetal     := "O valor do campo grupoTrib esta vazio."
				cMsgRes       := "Campo grupoTrib vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo grupoTrib nao existe." 
			cMsgDetal     := "O campo grupoTrib nao existe"
			cMsgRes       := "grupoTrib nulo"
			lOk           := .F.
		EndIf 

		

		// Valida o CPF/CNPJ com o tipo de pessoa
		If (len(jJson['cgc']) <> 11 .and. (jJson['pessoa']) == "F")
			cMsgRestFault := "Tamanho invalido de numero identificacao - tipo CPF." 
			cMsgDetal     := "Tamanho invalido de numero identificacao - tipo CPF."
			cMsgRes       := "Numero identificacao tamanho nao permitido - CPF"
			lOk           := .F.
		Elseif (len(jJson['cgc']) <> 14 .and. (jJson['pessoa']) == "J")
			cMsgRestFault := "Tamanho invalido de numero identificacao - tipo CNPJ." 
			cMsgDetal     := "Tamanho invalido de numero identificacao - tipo CNPJ."
			cMsgRes       := "Numero identificacao tamanho nao permitido - CNPJ"
			lOk           := .F.
		Endif

		// Valida o Estado
		If jJson:hasProperty('estado') .AND. ValType(jJson['estado']) == 'C'
			If Empty(jJson['estado'])
				cMsgRestFault := "O valor do campo estado esta vazio." 
				cMsgDetal     := "O valor do campo estado esta vazio."
				cMsgRes       := "Campo estado vazio"
				lOk           := .F.
			Else 
				dbSelectArea("SX5")
				dbSetOrder(1) // X5_TABELA+X5_CHAVE
				If !dbSeek( xFilial("SX5") + "12" + jJson['estado'] )
					cMsgRes       := "Codigo do estado do cliente esta invalido."
					cMsgRestFault := "O Codigo do estado informado esta invalido." 
					cMsgDetal     := "Codigo do estado do cliente esta invalido."
					lOk           := .F.	
				endif
			EndIf 
		Else 
			cMsgRestFault := "O campo estado nao existe." 
			cMsgDetal     := "O campo estado nao existe"
			cMsgRes       := "estado nulo"
			lOk           := .F.
		EndIf 
		
		// Valida o município 
		If jJson:hasProperty('municipio') .AND. ValType(jJson['municipio']) == 'C'
			If Empty(jJson['municipio'])
				cMsgRestFault := "O valor do campo municipio esta vazio." 
				cMsgDetal     := "O valor do campo municipio esta vazio."
				cMsgRes       := "Campo municipio vazio"
				lOk           := .F.
			Else 
				dbSelectArea("CC2")
				dbSetOrder(1) // CC2_FILIAL+CC2_EST+CC2_CODMUN
				If !dbSeek( xFilial("CC2") + jJson['estado'] + jJson['municipio'] )
					cMsgRes       := "Codigo do municipio do cliente esta invalido."
					cMsgRestFault := "O Codigo do municipio informado esta invalido."
					cMsgDetal     := "Codigo do municipio do cliente esta invalido."
					lOk           := .F.					 			
				Else 
					cCodMun := CC2->CC2_CODMUN
				EndIf
			EndIf 
		Else 
			cMsgRestFault := "O campo municipio nao existe."
			cMsgRes       := "municipio nulo"
			cMsgDetal     := "O campo municipio nao existe"
			lOk           := .F.
		EndIf 
		
		// Validação do País
		If jJson:hasProperty('pais') .AND. ValType(jJson['pais']) == 'C'
			If Empty(jJson['pais'])
				cMsgRestFault := "O valor do campo pais esta vazio." 
				cMsgDetal     := "O valor do campo pais esta vazio."
				cMsgRes       := "Campo pais vazio"
				lOk           := .F.
			Else 
				dbSelectArea("SYA")
				dbSetOrder(1) // SYA_FILIAL + SYA_CODGI
				If !dbSeek( xFilial("SYA") + jJson['pais'] )
					cMsgRes       := "Codigo do pais do cliente esta invalido."
					cMsgRestFault := "O Codigo do pais informado esta invalido." 
					cMsgDetal     := "Codigo do pais do cliente esta invalido."
					lOk           := .F.					 			
				EndIf
			EndIf 
		Else 
			cMsgRestFault := "O campo pais nao existe." 
			cMsgDetal     := "O campo pais nao existe"
			cMsgRes       := "pais nulo"
			lOk           := .F.
		EndIf 

		// Valida o endereço
		If jJson:hasProperty('endereco') .AND. ValType(jJson['endereco']) == 'C'
			If Empty(jJson['endereco'])
				cMsgRestFault := "O valor do campo endereco esta vazio." 
				cMsgDetal     := "O valor do campo endereco esta vazio."
				cMsgRes       := "Campo endereco vazio"
				lOk           := .F.
			EndIf 
		Else 
			cMsgRestFault := "O campo endereco nao existe."
			cMsgRes       := "endereco nulo"
			cMsgDetal     := "O campo endereco nao existe"
			lOk           := .F.
		EndIf 

		// Valida Vendedor1
		If jJson:hasProperty('vendedor1') .AND. ValType(jJson['vendedor1']) == 'C'
			If !Empty(jJson['vendedor1'])
				dbSelectArea("SA3") 
            	dbSetOrder(1) // A3_FILIAL + A3_CODIGO
            	If !dbSeek(xFilial("SA3") + jJson['vendedor1'])
					cMsgRestFault := "O Codigo do vendedor1 nao consta no Protheus." 
					cMsgDetal     := "O Codigo do vendedor1 nao consta no Protheus."
					cMsgRes       := "Campo vendedor1 vazio"
					lOk           := .F.
				Else 
					cVendedor1 := jJson['vendedor1']
				ENDIF
			EndIf 			 
		Else 
			cMsgRestFault := "O campo vendedor1 nao existe."
			cMsgRes       := "vendedor1 nulo"
			cMsgDetal     := "O campo vendedor1 nao existe"
			lOk           := .F.
		EndIf 

		// Valida Vendedor2 - OPCIONAL
		If jJson:hasProperty('vendedor2') .AND. ValType(jJson['vendedor2']) == 'C'
			If !Empty(jJson['vendedor2'])
				dbSelectArea("SA3")
            	dbSetOrder(1) // A3_FILIAL + A3_CODIGO
            	If !dbSeek(xFilial("SA3") + jJson['vendedor2'])
					cMsgRes       := "O Codigo do vendedor2 nao consta no Protheus.."
					cMsgRestFault := "O Codigo do vendedor2 nao consta no Protheus.." 
					cMsgDetal     := "O Codigo do vendedor2 nao consta no Protheus.."	
					lOk           := .F.
				Else 
					cVendedor2 := jJson['vendedor2']
				EndIf 
			EndIf 
		Else 
			cVendedor2 := ""
		EndIf 

		// Valida a Natureza - Opcional
		If jJson:hasProperty('natureza') .AND. ValType(jJson['natureza']) == 'C'
			If !Empty(jJson['natureza'])
				dbSelectArea("SED")
            	dbSetOrder(1) // ED_FILIAL + ED_CODIGO
            	If !dbSeek(xFilial("SED") + jJson['natureza'])
					cMsgRes       := "O Codigo da natureza nao consta no Protheus."
					cMsgRestFault := "O Codigo da natureza nao consta no Protheus." 
					cMsgDetal     := "O Codigo da natureza nao consta no Protheus."	
					lOk           := .F.
				Else 
					cNaturez := jJson['natureza']
				EndIf 
			Else 
				if AllTrim(jJson['estado']) <> 'EX'
					cNaturez := '4011110002'
				else 
					cNaturez := '4011110006'
				endif 
			EndIf 
		Else 
			if AllTrim(jJson['estado']) <> 'EX'
				cNaturez := '4011110002'
			else 
				cNaturez := '4011110006'
			endif 
		EndIf 

		// Valida a Banco - Opcional
		If jJson:hasProperty('banco') .AND. ValType(jJson['banco']) == 'C'
			cBanco := jJson['banco']
		else 
			cBanco := '' // Código do banco padrão em caso de falta de banco no cadastro
		EndIf 

		// Valida a Banco - Opcional
		If jJson:hasProperty('suframa') .AND. ValType(jJson['suframa']) == 'C'
			cSuframa := jJson['suframa']
		else 
			cSuframa := '' // Código do banco padrão em caso de falta de banco no cadastro
		EndIf 

		//Valida email
		If jJson:hasProperty('email') .AND. ValType(jJson['email']) == 'C'
			cEmail := jJson['email']
		EndIf 

		// Valida telefoneResidencial - OPCIONAL
		If jJson:hasProperty('telefoneResidencial') .AND. ValType(jJson['telefoneResidencial']) == 'C'
			cTelefoneResidencial := jJson['telefoneResidencial']
		EndIf 

		// Valida telefoneCelular - OPCIONAL
		If jJson:hasProperty('telefoneCelular') .AND. ValType(jJson['telefoneCelular']) == 'C'
			cTelefoneCelular := jJson['telefoneCelular']
		EndIf 

		// Valida complemento - OPCIONAL
		If jJson:hasProperty('complemento') .AND. ValType(jJson['complemento']) == 'C'
			cComplemento := jJson['complemento']
		EndIf 

		// Valida dataNascFund - OPCIONAL
		If jJson:hasProperty('dataNascFund') .AND. ValType(jJson['dataNascFund']) == 'C'
			dDataNascFund := StoD(jJson['dataNascFund'])
		EndIf 		

		// Valida inscricaoEst - OPCIONAL
		If jJson:hasProperty('inscricaoEst') .AND. ValType(jJson['inscricaoEst']) == 'C'
			cInscricaoEst := jJson['inscricaoEst']
		EndIf 

		// Valida inscricaoMun - OPCIONAL
		If jJson:hasProperty('inscricaoMun') .AND. ValType(jJson['inscricaoMun']) == 'C'
			cInscricaoMun := jJson['inscricaoMun']
		EndIf 

		// Valida rg - OPCIONAL
		If jJson:hasProperty('rg') .AND. ValType(jJson['rg']) == 'C'
			cRG := jJson['rg']
		EndIf 

		// Valida enderecoCob - OPCIONAL
		If jJson:hasProperty('enderecoCob') .AND. ValType(jJson['enderecoCob']) == 'C'
			cEnderecoCob := jJson['enderecoCob']
		EndIf 		

		
		//Valida campo TRANSPORTADORA - OPCIONAL	
		If jJson:hasProperty('transportadora') .AND. ValType(jJson['transportadora']) == 'C'
			If !Empty(jJson['transportadora'])
				dbSelectArea("SA4")
            	dbSetOrder(1) // A4_FILIAL + A4_COD
            	If !dbSeek(xFilial("SA4") + jJson['transportadora'])
					cMsgRes       := "O Codigo da tranportadora nao consta no Protheus.."
					cMsgRestFault := "O Codigo da tranportadora nao consta no Protheus.."
					cMsgDetal     := "O Codigo da tranportadora nao consta no Protheus.."	
					lOk           := .F.
				Else 
					cTransport := jJson['transportadora']
				EndIf 
			EndIf 
		Else 
			cTransport := ""
		EndIf 
	ENDIF

	If lOk
		//lDeuCerto := .F.
		DbSelectArea('SA1')
		DbSetOrder(1)
		dbseek(xFilial('SA1') + cCodigo)
		// Pegando o modelo de dados, setando a operaÃ§Ã£o de inclusÃ£o
		//oModel := FWLoadModel("CRMA980")
		//oModel:SetOperation(4) // 3 - Incluir, 4 - Alteraa, 5 - Exluir // tentar com 3 passando o código
		//oModel:Activate()
		nOpcAuto = 4  //Alteração
		ConOut("Realizando o PUT")
		
		// Pegando o model dos campos da SA1
		//oSA1Mod:= oModel:getModel("MATA030_SA1")
		aAdd(aSA1Auto,{"A1_COD"    , cCodigo                        ,NIL}) // Codigo 
		aAdd(aSA1Auto,{"A1_LOJA"   , jJson['loja']                  ,NIL}) // Loja
		aAdd(aSA1Auto,{"A1_NOME"   , SubStr(jJson['nome'],0,40)     ,NIL}) // Nome             
		aAdd(aSA1Auto,{"A1_NREDUZ" , SubStr(jJson['nomeReduz'],0,20),NIL}) // Nome reduz. 
		aAdd(aSA1Auto,{"A1_END"    , jJson['endereco']              ,NIL}) // Endereco
		aAdd(aSA1Auto,{"A1_ENDREC" , jJson['endereco']              ,NIL}) // End. de Receb. do cliente
		aAdd(aSA1Auto,{"A1_COMPLEM", cComplemento                   ,NIL}) // End. de Complemento
		aAdd(aSA1Auto,{"A1_BAIRRO" , jJson['bairro']                ,NIL}) // Bairro
		aAdd(aSA1Auto,{"A1_TIPO"   , jJson['tipo']                  ,NIL}) // Tipo 
		aAdd(aSA1Auto,{"A1_EST"    , jJson['estado']                ,NIL}) // Estado                
		aAdd(aSA1Auto,{"A1_MUN"    , jJson['municipio']             ,NIL}) // Municipio
		aAdd(aSA1Auto,{"A1_CEP"    , jJson['cep']                   ,NIL}) // CEP
		aAdd(aSA1Auto,{"A1_CGC"    , jJson['cgc']                   ,NIL}) // CNPJ/CPF            
		aAdd(aSA1Auto,{"A1_PAIS"   , jJson['pais']                  ,NIL}) // Pais                       
		aAdd(aSA1Auto,{"A1_PESSOA" , jJson['pessoa']                ,NIL}) // Tipo Pessoa
		aAdd(aSA1Auto,{"A1_VEND"   , jJson['vendedor1']             ,NIL}) // Vendedor 1
		aAdd(aSA1Auto,{"A1_GRPTRIB", jJson['grupoTrib']             ,NIL}) // Código do grupo tributário
		aAdd(aSA1Auto,{"A1_COD_MUN", cCodMun                        ,NIL}) // Cod Municipio
		aAdd(aSA1Auto,{"A1_NATUREZ", cNaturez                       ,NIL}) // Natureza
		aAdd(aSA1Auto,{"A1_EMAIL"  , cEmail                         ,NIL}) // E-mail
		aAdd(aSA1Auto,{"A1_TEL"    , cTelefoneResidencial           ,NIL}) // Telefone Comercial
		aAdd(aSA1Auto,{"A1_CEL"    , cTelefoneCelular               ,NIL}) // Telefone Celular
		aAdd(aSA1Auto,{"A1_DTNASC" , dDataNascFund                  ,NIL}) // Data de nascimento/fundação
		aAdd(aSA1Auto,{"A1_INSCR"  , cInscricaoEst                  ,NIL}) // Inscrição estadual
		aAdd(aSA1Auto,{"A1_RG"     , cRG                            ,NIL}) // RG
		aAdd(aSA1Auto,{"A1_INSCRM" , cInscricaoMun                  ,NIL}) // Inscrição Municipal
		aAdd(aSA1Auto,{"A1_VEND2"  , cVendedor2                     ,NIL}) // Vendedor 2
		aAdd(aSA1Auto,{"A1_ENDCOB" , cEnderecoCob                   ,NIL}) // End.de cobr. do cliente
		aAdd(aSA1Auto,{"A1_BCO1 "  , cBanco                         ,NIL}) // Banco padrão do cliente
		aAdd(aSA1Auto,{"A1_SUFRAMA", cSuframa                       ,NIL}) // Código Suframa do cliente
		aAdd(aSA1Auto,{"A1_TRANSP" , cTransport       			    ,NIL}) // Transportadora
		    
		CONOUT("Iniciando a alteracao")
        MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)

		If lMsErroAuto
            lRet := lMsErroAuto
			::SetContentType("application/json")
			//cErrorLog:="Erro de alteracao"
			aMsg := GetAutoGRLog()
                	aEval(aMsg,{|x| cErrorLog += x + CRLF })
                	SetRestfault(4,cErrorLog)
			//SetRestFault(4, cMsgRestFault)
            cMsgRes       := "Erro na alteracao"
			//cErrorLog     := "Erro - " + StrTran(FwNoAccent(aErro[6]),chr(13)+chr(10),'') + '"' 
			cMsgDetal := "Erro na alteracao"
			lOk := .F.
			//::SetResponse('{')
			//::SetResponse('"status": "2",')
			//::SetResponse('"erroDetalhes": "'+ "Erro - " + cErrorLog + '"' )
			//::SetResponse('}')
			U_FELSZ0( ''       ,; // Campos Chave
					  "CLIENTE",; // Rotina executada
					  Date()   ,; // Data da execucao
					  Time()   ,; // Hora da execucao
					  cMsgRes  ,; // Mensagem resumida
					  cMsgDetal,; // Mensagem detalhada
					  "PUT"    ,; // Tipo de operacao
					  "2"      ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
					  cBody     ) // Estrutura Json enviada na requisicao
        Else
			cMsgRes       := SA1->A1_COD
			cMsgDetal     := "Alterado com sucesso."
			lOk := .T.
			::SetResponse('{')
			::SetResponse('"status": "1",')
			::SetResponse('"filial": "'+xFilial('SA1')+'",')
			::SetResponse('"idCliente": "' + SA1->A1_COD + '"' )
			::SetResponse('}')
			U_FELSZ0( SA1->A1_COD,; // Campos Chave
					  "CLIENTE"  ,; // Rotina executada
					  Date()     ,; // Data da execucao
					  Time()     ,; // Hora da execucao
					  cMsgRes    ,; // Mensagem resumida
					  cMsgDetal  ,; // Mensagem detalhada
					  "PUT"     ,; // Tipo de operacao
					  "1"        ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
					  cBody)
        	Conout("Cliente incluido com sucesso!")
        EndIf

	else
		SetRestFault( 4, cMsgRestFault )
		U_FELSZ0( ''       ,; // Campos Chave
				  "CLIENTE",; // Rotina executada
				  Date()   ,; // Data da execucao
				  Time()   ,; // Hora da execucao
				  cMsgRes  ,; // Mensagem resumida
				  cMsgDetal,; // Mensagem detalhada
				  "PUT"   ,; // Tipo de operacao
				  "2"      ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
				  cBody     ) // Estrutura Json enviada na requisicao	
	
	EndIf 
	FreeObj(jJson)
Return lOk

WSMETHOD DELETE WSRECEIVE cCod WSSERVICE INCCLIENTE

	//Local lDeuCerto           := .F.
	//Local aErro               := {}
	Local lOk                 := .T.
    Local cCod   := ''  // Recebe os tratamentos para esse campo
	//Local aLojas := {}  // Recebe os tratamentos para esse campo
    //Local lOk    := .T. // Validações gerais 



	// Variáveis do Objeto Json 
	Local cBody   := FwNoAccent(DecodeUTF8(::GetContent()))
    //Local jJson   := JsonObject():New()
	//Local cRet    := ""
	//Local cCodigo := ""

	// Variáveis do Log
	Local cMsgRestFault        := ""
	Local cMsgRes              := ""
	Local cMsgDetal            := ""

	// Objeto Json 
    Local jGetJson := JsonObject():New() // Monta o json de retorno 

	::SetContentType("application/json")
	ConOut("EXECUTANDO DELETE INCCLIENTE")
	ConOut( cBody )

  	if ValType( ::cCod ) == "U" .Or. Empty( ::cCod )
       cMsgRestFault := "Campo cCod esta vazio ou nao existe."
       cMsgRes       := "Campo cCod nao recebido."
       cMsgDetal     := "Campo cCod esta vazio ou nao existe."
       lOk := .F. 
	else // Trata o campo
        cCod := PadL(::cCod,TAMSX3("A1_COD")[1],'0')
    endif 
    	
	If lOk
		//lDeuCerto := .F.
		DBSELECTAREA("SA1")
   		DbSetOrder(1) // A1_FILIAL+A1_COD+A1_LOJA
   
    	if DbSeek(xFilial("SA1") + self:cCod) 
        	RecLock("SA1", .F.)
        		DbDelete()
        	MsUnlock()
			      
        	jGetJson['idCliente'] := AllTrim(cCod)
            cMsgRes       := "Cliente deletado."
            cMsgDetal     := "Cliente deletado com sucesso. " + cCod
            ::SetResponse(jGetJson:toJson())
			::SetResponse('{')
			::SetResponse('"status": "Deletado",')
			::SetResponse('}')
            
			U_FELSZ0( cCod            ,; // Campos Chave
		              "INCCLIENTE"    ,; // Rotina executada
		              Date()          ,; // Data da execucao
		              Time()          ,; // Hora da execucao
		              cMsgRes         ,; // Mensagem resumida
		              cMsgDetal       ,; // Mensagem detalhada
		              "DELETE"           ,; // Tipo de operacao
		              "1"             ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
		              jGetJson:toJson()) // Estrutura Json enviada na requisicao
		else
			cMsgRestFault := "Chave nao encontrada para delecao. " + cCod
            cMsgRes       := "Chave nao encontrada para delecao."
            cMsgDetal     := "Chave nao encontrada para delecao " + cCod
            SetRestFault( 4, cMsgRestFault )
			lOk:= .F.

			U_FELSZ0( cCod            ,; // Campos Chave
		              "INCCLIENTE"    ,; // Rotina executada
		              Date()          ,; // Data da execucao
		              Time()          ,; // Hora da execucao
		              cMsgRes         ,; // Mensagem resumida
		              cMsgDetal       ,; // Mensagem detalhada
		              "DELETE"           ,; // Tipo de operacao
		              "2"             ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
		              jGetJson:toJson()) // Estrutura Json enviada na requisicao
        endif
	else 
        SetRestFault( 4, cMsgRestFault )
        U_FELSZ0( ''              ,; // Campos Chave
		          "INCCLIENTE"    ,; // Rotina executada
		          Date()          ,; // Data da execucao
		          Time()          ,; // Hora da execucao
		          cMsgRes         ,; // Mensagem resumida
		          cMsgDetal       ,; // Mensagem detalhada
		          "DELETE"           ,; // Tipo de operacao
		          "2"             ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
		          '')                // Estrutura Json enviada na requisicao
    endif 
	FreeObj(jGetJson)
Return lOk



/*
			// Pegando o modelo de dados, setando a operação de exclusão
			oModel := FWLoadModel("MATA030")
			oModel:SetOperation(5) // 3 - Incluir, 4 - Alteraa, 5 - Exluir
			oModel:Activate()

			// Pegando o model dos campos da SA1
			oSA1Mod:= oModel:getModel("MATA030_SA1")
			oSA1Mod:setValue("A1_COD"    , cCodigo                        ) // Codigo 
			oSA1Mod:setValue("A1_LOJA"   , jJson['loja']                  ) // Loja

			If oModel:VldData()
			
				// Tenta realizar o commit
				If oModel:CommitData()
					lDeuCerto := .T.
			
				// Se nao deu certo, altera a variavel para false
				Else
					lDeuCerto := .F.
				EndIf
			
			// Se nao conseguir validar as informaçoes, altera a variavel para false
			Else
				lDeuCerto := .F.
			EndIf
			
			// Se nao deu certo a inclusao, mostra a mensagem de erro
			If ! lDeuCerto
				//Busca o Erro do Modelo de Dados
				aErro := oModel:GetErrorMessage()
				cMsgRes       := "Erro de delecao"
				cMsgDetal     := "Erro - " + StrTran(FwNoAccent(aErro[6]),chr(13)+chr(10),'')
				lOk := .F.

				::SetResponse('{')
				::SetResponse('"status": "2",')
				::SetResponse('"erroDetalhes": "'+"Erro - " + StrTran(FwNoAccent(aErro[6]),chr(13)+chr(10),'') + '"' )
				::SetResponse('}')

				U_FELSZ0( ''       ,; // Campos Chave
						  "CLIENTE",; // Rotina executada
						  Date()   ,; // Data da execucao
						  Time()   ,; // Hora da execucao
						  cMsgRes  ,; // Mensagem resumida
						  cMsgDetal,; // Mensagem detalhada
						  "DELETE" ,; // Tipo de operacao
						  "2"      ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
						  cBody     ) // Estrutura Json enviada na requisicao	
			Else 
				cMsgRes       := SA1->A1_COD
				cMsgDetal     := "Cliente Deletado com sucesso."
				lOk := .T.
				
				::SetResponse('{')
				::SetResponse('"status": "1",')
				::SetResponse('"filial": "'+xFilial('SA1')+'",')
				::SetResponse('"idCliente": "' + SA1->A1_COD + '"' )
				::SetResponse('}')

				U_FELSZ0( SA1->A1_COD,; // Campos Chave
						  "CLIENTE"  ,; // Rotina executada
						  Date()     ,; // Data da execucao
						  Time()     ,; // Hora da execucao
						  cMsgRes    ,; // Mensagem resumida
						  cMsgDetal  ,; // Mensagem detalhada
						  "DELETE"   ,; // Tipo de operacao
						  "1"        ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
						  cBody       ) // Estrutura Json enviada na requisicao	
			Endif
			
			// Desativa o modelo de dados
			oModel:DeActivate()
		else
			SetRestFault( 4, cMsgRestFault )
			U_FELSZ0( ''       ,; // Campos Chave
					  "CLIENTE",; // Rotina executada
					  Date()   ,; // Data da execucao
					  Time()   ,; // Hora da execucao
					  cMsgRes  ,; // Mensagem resumida
					  cMsgDetal,; // Mensagem detalhada
					  "DELETE" ,; // Tipo de operacao
					  "2"      ,; // Tipo de ocorrencia (1 = OK, 2 = Erro)
					  cBody     ) // Estrutura Json enviada na requisicao	
		endif*/
