#Include "Protheus.ch"
#Include "Restful.ch"
#Include "Totvs.ch"
#INCLUDE "RWMAKE.CH"
#include "tbiconn.ch"


User Function FELSZ0 (cId, cRotina, dData, cHora, cDesc, cObs, cTipo, cStatus, cJson)


Private aButtons    := {}
Private cCadastro   := "Log de Integração WS"
Private aRotina     := MenuDef()
Private aCores      :={ { '(SZ0->Z0_STATUS = "1")', 'BR_VERDE'  },;
                        { '(SZ0->Z0_STATUS = "2")', 'BR_VERMELHO'}}

 
    dbSelectArea('SZ0')

    If !(FunName() = "ZENA010") // não é a ZENA010
        A010SALV(cId, cRotina, dData, cHora, cDesc, cObs, cTipo, cStatus, cJson)
    Else
        mBrowse(6,1,22,75,"SZ0",,,,,,aCores)
    EndIf

 

Return

 

Static Function MenuDef()
    Local aRotina := {}

    aAdd(aRotina,{ "Pesquisar"      ,"AxPesqui"         , 0, 1})
    aAdd(aRotina,{ "Visualizar"     ,"u_A010BROW"       , 0, 2})
    aAdd(aRotina,{ "Legenda"        ,"u_A010LEG"        , 0, 7})

 

Return( aRotina )

 

User Function A010LEG()

    BrwLegenda("Legenda","Legenda",     {{"BR_VERDE"        ,"OK"},;
                                         {"BR_VERMELHO"    ,"ERRO"}})

 

Return

 

Static Function A010SALV(cId, cRotina, dData, cHora, cDesc, cObs, cTipo, cStatus, cJson)


    RecLock( "SZ0", .T. )
        SZ0->Z0_FILIAL  := xFilial('SZ0')
        SZ0->Z0_ID      := cId
        SZ0->Z0_ROTINA  := cRotina
        SZ0->Z0_DATA    := dData
        SZ0->Z0_HORA    := cHora
        SZ0->Z0_DESC    := cDesc
        SZ0->Z0_OBS     := cObs
        SZ0->Z0_TIPO    := cTipo
        SZ0->Z0_STATUS  := cStatus
        SZ0->Z0_JSONREC := cJson
    MsUnLock()

 

Return

 

 

User Function A010BROW()
    Local cObs := SZ0->Z0_OBS
    Local aAcho     := {"NOUSER", "Z0_ID", "Z0_ROTINA", "Z0_DATA", "Z0_HORA", "Z0_DESC", "Z0_TIPO"} // Campos que aparecem no MsMGet
    Local aCpos     := {}                                                                           // Campos que podem ser alterados no MsMGet

 

    oSize := FwDefSize():New()                          // Calcula o valor total da tela
    oSize:AddObject( "MGET", 100, 20, .T., .T. )        // Ocupa 30% da Tela
    oSize:AddObject( "PANEL", 100, 80, .T., .T. )       // Ocupa 30% da Tela
    oSize:lProp := .T.                                  // Redimensiona os Objetos do oSize
    oSize:Process()                                     // Calcula o valor dos objetos e mantém na tela

 

    DEFINE MSDIALOG oDlg TITLE "Visualizar" FROM    oSize:aWindSize[1],oSize:aWindSize[2] TO ;
                                                    oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

 

    RegToMemory( "SZ0", .F.)

    oEnChoice:=MsMGet():New("SZ0", ,2 , , , ,aAcho , {  oSize:GetDimension("MGET","LININI"),;
                                                        oSize:GetDimension("MGET","COLINI"),;
                                                        oSize:GetDimension("MGET","LINEND"),;
                                                        oSize:GetDimension("MGET","COLEND")},;
                                                aCpos, 3, , , ,oDlg , ,.T. )

 

    @oSize:GetDimension("PANEL","LININI"), oSize:GetDimension("PANEL","COLINI") TO;
     oSize:GetDimension("PANEL","LINEND"), oSize:GetDimension("PANEL","COLEND") Label "" OF oDlg PIXEL


    oSay2:= TSay():New(77,10,{||'Detalhes: '},oDlg,,,,,,.T.,,,200,20)
    oMemo := tMultiget():new( 85, 10, {||cObs := SZ0->Z0_OBS  }, oDlg, 180, 130, , , , , , .T. )
    oMemo:lReadOnly := .T.
 
    ACTIVATE MSDIALOG oDlg ON INIT Eval({ || EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},.F.,aButtons)  })

 

Return
