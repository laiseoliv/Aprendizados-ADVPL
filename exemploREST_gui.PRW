#Include "Protheus.ch"
#Include "Restful.ch"


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

WSRESTFUL FELPEDIDOVENDA DESCRIPTION "Metodos de Pedido de Venda"
    //WSDATA cFil     	AS STRING 
	//WSDATA cNum    	    AS STRING

    WSMETHOD GET    DESCRIPTION "Consulta pedido de venda"  WSSYNTAX ""
    WSMETHOD POST   DESCRIPTION "Inclusao pedido de venda"  WSSYNTAX ""
    WSMETHOD PUT    DESCRIPTION "Liberacao pedido de venda" WSSYNTAX ""
    WSMETHOD DELETE DESCRIPTION "Delecao pedido de venda"   WSSYNTAX ""

END WSRESTFUL


WSMETHOD GET WSSERVICE FELPEDIDOVENDA

    
Return .T. //sempre tem que ter retorno V ou F. Falso retorna erro

WSMETHOD POST WSSERVICE FELPEDIDOVENDA

   
Return .T.

WSMETHOD PUT WSSERVICE FELPEDIDOVENDA 

    
Return .T.

WSMETHOD DELETE WSRECEIVE cFil, cNum WSSERVICE FELPEDIDOVENDA

    
return .T.

