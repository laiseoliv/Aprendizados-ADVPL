#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function MBRW00
d
    escription)
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
User Function MBRW00()
    Local cAlias := "SB1"
    Private cTitulo := "Cadastro Produtos MBROWSE"
    Private aRotina := {}

                    //              //Padrão        
    AADD(aRotina, {"Pesquisar"   , "AxPesqui"     , 0,1})
    AADD(aRotina, {"Visualizar"  , "AxVisual"     , 0,2})
    AADD(aRotina, {"Incluir"     , "AxInclui"     , 0,3})
    AADD(aRotina, {"Trocar"      , "AxAltera"     , 0,4})
    AADD(aRotina, {"Excluir"     , "AxDeleta"     , 0,5}) 
    AADD(aRotina, {"OlaMundo"    , "U_OLAMUNDO"   , 0,1})

    DBSELECTAREA(cAlias)
    DBSETORDER(1)
    MBROWSE(,,,,cAlias)
    //MBROWSE(6,1,22,75,cAlias)

Return
