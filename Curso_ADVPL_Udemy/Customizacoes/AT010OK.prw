#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

//Pontos de entradas s�o nomes reservedos pela TOTVS em fun��es padr�es.

User Function AT010OK()
    Local lExecuta := .T.
    Local cTipo := ALLTRIM(M->B1_TIPO)
    Local cConta := ALLTRIM(M->B1_CONTA)

    if  (cTipo = "PA" .AND. cConta - "001")

        Alert("A conta <b> " + cConta + "</b> n�o pode estar associada a um produto do tipo <b>" + cTipo)
        
        lExecuta := .F.

    endif
    
Return (lExecuta) //tem que colocar o lExecuta no Return para que de fato o usuario n�o execute fun��o, pois o exercicio pede para que n�o seja possivel colocar no cadastro o Tipo PA e a conta contabil 001
