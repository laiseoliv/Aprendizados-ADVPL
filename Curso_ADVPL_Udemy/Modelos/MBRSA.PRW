#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

User Function MBRSA2()
    Local cAlias       := "SA2"
    Local aCores       := {}
    Local cFiltra      := "A2_FILIAL ==' " + xFilial('SA2')+"' .And. A2_EST == 'SP'"
    Private cCadastro  := "Cadastro MBROWSE"
    Private aRotina    := {}
    Private aIndexSA2  := {}
    Private bFiltraBrw := {|| FilBrowse(cAlias, @aIndexSA2, @cFiltra)}
                                                //faz referencia a aIndexSA2, faz referencia a cFiltra              
        
    AADD(aRotina, {"Pesquisar"   , "AxPesqui"      , 0,1})
    AADD(aRotina, {"Visualizar"  , "AxVisual"      , 0,2})
    AADD(aRotina, {"Incluir"     , "U_BInclui"     , 0,3})
    AADD(aRotina, {"Trocar"      , "U_BAltera"     , 0,4})
    AADD(aRotina, {"Excluir"     , "U_BDeleta"     , 0,5}) 
    AADD(aRotina, {"Legenda"     , "U_BLegenda"    , 0,1})

    //aCores - Legenda
    AADD(aCores, {"A2_TIPO == 'F'", "BR_VERDE"  }) //Estou pedindo com esse codigo, que se for cadastro com TIPO Pessoa Fisica, a cor da legenda ser� Verde
    AADD(aCores, {"A2_TIPO == 'J'", "BR_AMARELO"})
    AADD(aCores, {"A2_TIPO == 'X'", "BR_LARANJA"})
    AADD(aCores, {"A2_TIPO == 'R'", "BR_MARROM" })
    AADD(aCores, {"Empty(A2_TIPO)", "BR_VERDE"  }) // N�O FOR CLASSIFICADO // EMPTY significa VAZIO



    DBSELECTAREA(cAlias)
    DBSETORDER(1)
    Eval(bFiltraBrw)
    DBGOTOP()
    //MBROWSE(,,,,cAlias)
    MBROWSE(6,1,22,75,cAlias,,,,,,aCores)

    EndFilBrw(cAlias, aIndexSA2)
Return

/*----------------------
    Fun��o BInclui - Inclus�o
------------------------*/

User Function BInclui(cAlias, nReg, nOpc)
    Local nOpcao := 0
    nOpcao: = AxInclui(cAlias, nReg, nOpc)
        if nOpcao == 1
        MSGINFO("Inclus�o efetuada com sucesso!")
        else
            MSGALERT("Inclus�o Cancelada")
        endif   
Return

/*----------------------
    Fun��o BLegenda - Legenda
------------------------*/

User Function BAltera(cAlias, nReg, nOpc)
    Local nOpcao := 0
    nOpcao: = AxAltera(cAlias, nReg, nOpc)
        if nOpcao == 1
        MSGINFO("Altera��o efetuada com sucesso!")
        else
            MSGALERT("Altera��o Cancelada")
        endif   
Return

/*----------------------
    Fun��o BDeleta - Exclus�o
------------------------*/

User Function BDeleta(cAlias, nReg, nOpc)
    Local nOpcao := 0
    nOpcao: = AxDeleta(cAlias, nReg, nOpc)
        if nOpcao == 1
        MSGINFO("Exclus�o efetuada com sucesso!")
        else
            MSGALERT("Exclus�o Cancelada")
        endif   
Return

/*----------------------
    Fun��o BLegenda - Legenda
------------------------*/
User Function BLegenda()
    Local aLegenda := {}

    AADD(aLegenda, {"BR_VERDE", "Pessoa Fisica"})
    AADD(aLegenda, {"BR_AMARELO", "Pessoa Juridica"})
    AADD(aLegenda, {"BR_LARANJA", "Exporta��o"})
    AADD(aLegenda, {"BR_MARROM", "Fornecedor Rural"})
    AADD(aLegenda, {"BR_PRETO", "N�o Classificado"})

    BrwLegenda(cCadastro, "Legenda", aLegenda)
    
Return
