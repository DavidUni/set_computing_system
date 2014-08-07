/***********************************************************************
 SECCIÓN DE DECLARACIONES DE BISON
************************************************************************
 Contiene:
    - Declaraciones en C++.
    - Declaraciones de Bison.
*/


    /* DECLARACIONES EN C++
    ---------------------------------------------------
        Todo lo que aparezca, a continuación, entre los símbolos '%{ %}' se copiará, tal cual, en el archivo 'set_bison_parser.c' justo debajo del comentario 'Copy the first part of user declarations.'. Por lo tanto, debe ser código C++ válido.  El archivo 'set_bison_parser.c' se genera cuando se ejecuta la orden del makefile 'bison set_bison_parser.y'. */
        %{
            #include <iostream>// Necesaria para usar el objeto 'cout' y la función 'endl'.
            using namespace std;// Para utilizar el espacio de nombres de std, en concreto se utilizarán los nombres 'cout' y 'endl'.
            
            int yylex();// El analizador sintáctico generado con Bison utiliza como analizador léxico una función llamada 'yylex()', pero ni la declara ni la define, así que es necesario declárala como hacemos aquí. De su definición se encargará el generador de analizadores léxicos Flex.

            bool flex_EOF = false;

            int yyerror(char const* msj);
        %}
    /* FIN de las declaraciones en C++ 
    ---------------------------------------------------*/


 
    /* DECLARACIONES DE BISON 
    ---------------------------------------------------*/

        /* NOTA: Por convención, los símbolos NO terminales de la gramática (sentencias, expresiones, declaraciones, definición de función...) se escribirán en minúscula. Los símbolos terminales o tokens se escribirán en MAYÚSCULA. */

        /* Esta sección de declaraciones sirve para especificar cuales serán los símbolo NO terminales (tokens) que pueden aparecer en la gramática. Aquí también se especifica cual es el tipo del valor semántico de cada token. Por ejemplo, si el analizador de Bison encuentra el número '84747' lo calificará como un token 'ENTERO' si hemos declarado más abajo el token 'ENTERO' y, además, en el archivo de flex 'set_lexer_flex' hemos declarado la siguiente definición de nombre:
        
        ENTERO      [0-9]+
        
        Bison también almacenará su valor semántico (el número '84747') en un variable de tipo entero.
        */

        /* La declaración '%union' especifica la colección completa de los posibles tipos de datos que los valores semánticos de los tokens pueden tener. */
        %union
        {
            int entero;
            string* texto;
        }

        /* La construcción de Bison '%token' se utiliza para declarar los símbolos de nuestra gramática que son terminales. Para especificar el tipo dato de cada token se utilizan los ángulos '<tipo>' y entre ellos se escribe el nombre del identificador de la estructura unión que tiene como tipo de dato, el que queramos que tenga el token. 
        [token = símbolo no terminal] */
        %token END_SEN
        %token <texto> IDENTIFICADOR RESERVADA OPE_LOG ASIGNAR
        %token <entero> ENTERO

        /* La construcción de Bison '%type' se utiliza para declarar los símbolos de nuestra gramática que NO son terminales. Para especificar el tipo de cada símbolo no terminal se utilizan los ángulos '<tipo>'.
        [type = símbolo terminal]
        */
        //%type <entero> termino factor

        %start input/* Cuando se construye una gramática libre de contexto, por definición, siempre es necesario especificar cual es símbolo NO terminal por el cual deben comenzar a hacerse las derivaciones (símbolo inicial). En Bison ésto se especifica con '%start'.  Si no se especifica '%start', Bison asume que el símbolo de arranque para la gramática es el primer no terminal que se encuentra en la sección de la especificación de la gramática (la sección de reglas) */     
    /* FIN de las declaraciones de Bison
    ---------------------------------------------------*/

/* Fin de la sección de declaraciones 
***********************************************************************/

%%

/***********************************************************************
 SECCIÓN DE REGLAS DE BISON
************************************************************************/

input   :                   {   /* El programa vacío es válido. */
                                cout << endl << " input : épsilon ";
                            }
        | input sentence    {
                                cout << endl << " input : input sentence ";
                                if ( flex_EOF )/* Si Flex alcanzo el fin de archivo (ver el archivo 'set_lexer_flex.l') y toda la 'input' (entrada) cuadra con la gramática, aceptamos el programa fuente como válido. */
                                {
                                    cout << endl << endl << "\t EOF !!!" << endl;
                                    YYACCEPT; /* "YYACCEPT" es una macro que retorna inmediatamente con el valor 0 (para indicar éxito). Es totalmente necesario llamar a esta macro ya que cuando se alcanza el fin de archivo, Flex devuelve el token "END_SEN" (ver archivo 'set_lexer_flex.l') lo que provoca que Bison vuelva a llamar de nuevo a Flex, entonces Flex vuelve a enviar el token 'END_SEN' ya que estamos en 'EOF' y así sucesivamente de manera infinita. Por lo tanto, la única forma de salir de este bucle infinito es con 'YYACCEPT' que sólo se ejecuta cuando  'flex_EOF = true' y toda la 'input' (entrada) cuadra con la gramática. */
                                }
                            }
;

/* "END_SEN" significa "símbolo terminal que indica el final de una sentence". */
sentence : asignacion  END_SEN {
                                    cout << endl << " sentence : asignacion END_SEN ";
                                }
            | END_SEN           {
                                    cout << endl << " sentence : END_SEN ";
                                }
;

asignacion : IDENTIFICADOR ASIGNAR ENTERO   {
                                                cout << endl << " asignacion : IDENTIFICADOR ASIGNAR ENTERO ";
                                            }
;
/* FIN de la sección de reglas de Bison 
*************************************************************************/

%%

/*************************************************************************
 CÓDIGO C++ adicional
**************************************************************************/
    int yyerror(char const* msj)
    {
        cerr << "  " << msj << endl;
        return 1;
    }
/* FIN del código C++ adicional
************************************************************************/