#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'


/*/{Protheus.doc} User Function AVETOR2
    (long_description)
    @type  Function
    @author user
    @since 25/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function AVETOR2()
     /**
        ADD() - Permite a inser��o de um item em um Array j� existente
        AINS() - Permite  a inser��o de um elemento em qualquer posi��o do Array
        ACLONE() - Realiza a c�pia de um Array para outro
        ADEL() - Permite a exclus�o de um elemento do Array, tornando o ulitmo valor NULL
        ASIZE() - Redefine a estrutura de um Array pr�-existente, adicionando ou removando itens.
        LEN() - Retorna a quantidade de elementos de um Array
**/

    Local aVetor := {10,20,30}
       //AADD( aVetor, 40)
      //Alert(Len(aVetor))

      //AINS( aVetor, 2)
      //aVetor[2] := 200
      //Alert(aVetor[2])
      //Alert(LEN(aVetor))
        
       /* Local aVet2 := ACLONE(aVetor)
        Local nCount
           
            for nCount := 1 to Len(aVet2)
                Alert(aVet2[nCount])
            
           next nCount */
           
        //Adel(aVetor,2)
        //Alert(aVetor[2])
        //Alert(Len(aVetor))
        Local nCount
        ASIZE(aVetor, 2)  // - estou definindo que meu array ter� 2 posi��es. o ASIZE vai excluir o ultimo
        Alert(Len(aVetor))
        
            for nCount := 1 to Len(aVetor)
                Alert(aVetor[nCount])
            
           next nCount
    
Return
