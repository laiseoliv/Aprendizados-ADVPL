#include "protheus.ch"
#include "restful.ch"


//********  REST QUE DEU CERTO!


WSRESTFUL helloworld DESCRIPTION "Testando Meu Primeiro serviço REST!"
    WSMETHOD GET DESCRIPTION "Retornar um Hello World" 
END WSRESTFUL

WSMETHOD GET WSSERVICE helloworld
    ::setResponse('[{"Status":"Hello World"}]') //json
return .T.




