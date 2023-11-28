
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} User Function BANCO001
)
    Local aArea := SB1 -> (GetArea())
    Local cMsg := ""escription)
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
User Function BANCO001()
    Local aArea := SB1 -> (GetArea())
    //Local cMsg := ""

    DBSELECTAREA("SB1") //Abre a tabela que está entre parenteses, nesse caso SB1
    SB1->(DBSETORDER(1)) //Localiza ou posiciona no indice que se quer, nesse caso o indice é 1.
    SB1->(DBGOTOP()) // posiciona no topo da tabela escolhida

    //posiciona o produto  de codigo 000002
    if SB1 -> (DBSEEK(FWXFilial("SB1") + "000002"))  // vai correr a tabela SB1, na filia logada no sistema (FWZFilial), procurando o codigo 000002
        Alert(SB1->B1_DESC) // vai imprimir na tela o campo onde está o codigo. Nessa caso o codigo está no campo B1_DESC da tabela SB1.
        
    endif
    
    RestArea(aArea) // esse comando fecha a tabela que abri (GetArea()). Sempre dar o comando RestArea toda vez que abro uma tabela. Assim, se fecha a tabela para deixar livre para rodar no Protheus.


Return

