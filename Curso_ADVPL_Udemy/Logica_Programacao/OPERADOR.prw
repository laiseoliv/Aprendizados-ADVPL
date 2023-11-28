#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

User Function OPERADOR ()
    Local nNum1 := 10
    Local nNum2 := 20

    // OPERADORES MATEMÁTICOS
/*
    Alert (nNum1 + nNum2)
    Alert (nNum2 - nNum1)
    Alert (nNum1 * nNum2)
    Alert (nNum2 / nNum1)
    Alert (nNUm2 % nNum1)
*/

    // OPERADORES RELACIONAIS

    Alert (nNum1 < nNum2)  // MAIOR QUE
    Alert (nNum1 > nNum2)  // MENOR QUE
    Alert (nNum1 = nNum2)  // IGUAL A - COMPARAÇÃO DE IGUALDADE
    Alert (nNum1 == nNum2) // EXATAMENTE IGUAL - CARACTERES
    Alert (nNum1 <= nNum2) // MENOR OU IGUAL A 
    Alert (nNum1 >= nNum2) // MAIOR OU IGUAL A 
    Alert (nNum1 != nNum2) // DIFERENÇA
// NESSE CASO, O RETORNO SERÁ LÓGICO (TRUE/FALSE)

/*
    // OPERADORES DE ATRIBUIÇÃO
    nNum1 := 10 // atribuição simples
    nNum1 += nNum2 // nNum1 = nNum1 + nNum2
    nNum2 -= nNum1 // nNum2 = nNum2 - nNum1
    nNum1 *= nNum2 // nNum1 = nNum1 * nNum2
    nNum2 /= nNum1 // nNum2 = nNum2 / nNum1
    nNum2 %= nNum1 // nNum2 = nNum2 % nNum1
*/


return
