#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE 'TopConn.ch'  // biblioteca para chamar as Query's

/*/{Protheus.doc} User Function BANCO003
    (long_description)
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
User Function BANCO003()
    Local aArea := SB1->(GetArea())
    Local cQuery := ""
    Local aDados := {}
    Local nCount

    cQuery := " SELECT "
    cQuery += " B1_COD AS CODIGO, "  // A PARTIR DESSA LINHA SE USA O += PARA NÃO SOBRESCREVER O cQuery := " SELECT "
    cQuery += " B1_DESC AS DESCRICAO "
    cQuery += " FROM "
    cQuery += " " + RetSQLName("SB1") + "SB1"
    cQuery += " WHERE "
    cQuery += " B1_MSBLQL != '1' "

    //Executando a consulta acima
    TCQuery cQuery New Alias "TMP" // estamos exectuando a tabela temporaria que foi criada acima

    while ! TMP->(EOF()) //Enquanto(while) a nossa tabela temporaria(TMP) não(!) estiver no final(EOF)
        AADD(aDados, TMP->CODIGO)
        AADD(aDados, TMP->DESCRICAO)
        TMP->(DbSKip())
    end

        Alert(Len(aDados))
        
        for nCount := 1 to Len(aDados)
            MSGINFO(aDados[nCount])
            
         next nCount

         TMP->(DBCLOSEAREA())
         RestArea(aArea)
     
        
Return
