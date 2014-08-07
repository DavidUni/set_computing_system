/***********************************************************************
 SECCIÓN DE DEFINICIONES DE FLEX
************************************************************************
 Contiene:
   - Declaraciones en C++.
   - Declaraciones de condiciones de arranque.
   - Declaraciones de definiciones nombres.
*/


/* DECLARACIONES EN C++
-----------------------------------------------------
Es cualquier texto sangrado o encerrado entre '%{' y '}%'. Este texto se copia íntegramente a la salida (a lex.yy.c) sin los '%{}%', por lo tanto, debe ser código C++ válido. Los '%{' y '}%' DEBEN ser los dos primeros caracteres de la línea en la que aparezcan, es decir, previamente a ellos debe haber algún salto de línea o nada. */

%{
   #include <iostream>// Necesaria para usar el objeto 'cout' y la función 'endl'.
   using namespace std;// Para utilizar el espacio de nombres de std, en concreto se utilizarán los nombres 'cout' y 'endl'.
   #include "set_bison_parser.tab.h"
   extern bool flex_EOF;
%}

/* FIN de las declaraciones en C ++ 
-----------------------------------------------------*/



/* DECLARACIONES DE CONDICIONES DE ARRANQUE:
----------------------------------------------------*/

%option noyywrap

/* El archivo de salida generado por Flex se llamará 'set_flex_lexer.yy.c'.*/
%option outfile="set_flex_lexer.yy.c"

/* FIN de declaraciones de condicione de arranque 
-----------------------------------------------------*/

    

/* DECLARACIONES DE DEFINCIONES DE NOMBRES:
-------------------------------------------------------
Son macros con nombres sencillos que se utilizan en la sección de reglas para simplificar la especificación del escáner (mejorar su legibilidad). Tienen la forma

nombre definición

donde el "nombre" es una palabra que se escribe al principio de la línea (es decir, previamente a él debe haber algún salto de línea o nada) y que comienza con una letra o un subrayado ('_') seguido por cero o más letras, '_' o '-' (guión). La definición se considera que comienza en el primer carácter que no sea un espacio en blanco siguiendo al nombre y continuando hasta el final de la línea. La definición no es más que una expresión regular, es decir, un patrón que define un conjunto de cadenas de caracteres. En la sección de reglas se puede hacer referencia a la definición utilizando {nombre}, que se expandirá a "definición". */

IDENTIFICADOR       [a-zA-Z][a-zA-Z0-9]*
ENTERO              [0-9]+
BLANCOS             [ \t]*
RESERVADA           while
OPE_LOG             <|>|≤|≥|⋀|⋁|⊻|¬
END_SEN             [\n]
ASIGNAR             ←
/* FIN de las definiciones de nombres 
-----------------------------------------------------*/

/* FIN de la sección de definiciones 
***********************************************************************/




/***********************************************************************
SECCIÓN DE REGLAS. 
   Contiene una serie de reglas de la forma:

   patrón acción

   Variables:
   - yylval: almacena el valor semántico del token.
*/
%%

{RESERVADA}       {
                     yylval.texto = new string(yytext);
                     return RESERVADA;
                  }

{IDENTIFICADOR}   {
                     yylval.texto = new string(yytext);
                     return IDENTIFICADOR;
                  }

{BLANCOS}         ;
                    

{ENTERO}          {
                     yylval.entero=atoi(yytext);
                     return ENTERO;
                  }

{OPE_LOG}         {
                     yylval.texto = new string(yytext);
                     return OPE_LOG;
                  }

[-+*/();{}]       {
                        /* Si se quiere que se detecte el símbolo menos '-' como parte de una expresión regular, nunca debe colocarse entre dos símbolos de la expresión regular ya que esto indicaría un rango. */
                        return *yytext;
                  }

{ASIGNAR}         {
                     yylval.texto = new string(yytext);
                     return ASIGNAR;
                  }

{END_SEN}         {
                     /* "END_SEN" significa "símbolo terminal que indica el final de una sentencia". */
                     return END_SEN;
                  }

.                 {
                     cout << endl <<"Error léxico, caracter (" << *yytext << ") desconocido\n";
                  }

<<EOF>>           {
                     flex_EOF = true;
                     return END_SEN;/* El final de cada sentencia del lenguaje Set se indica con el token "END_SEN" (ver archivo set_bison_parser.y), actualmente, este token es un "\n" (salto de línea). Pero también queremos que se acepte como válida aquella sentencia que se encuentra en la última línea del archivo fuente y que no le sigue nada, ni siquiera un salto de línea (sólo el fin de archivo "<<EOF>>"). Para ello Flex devuelve "END_SEN" cuando detecte el fin de archivo "<<EOF>>". Si cuando llegamos al final de archivo se devuelve un token, en este caso "END_SEN", entonces Bison cree que no se ha alcanzado el final del archivo y volverá a llamar a Flex que de nuevo le retornará "END_SEN" puesto que estamos en "EOF". Para salir de este bucle infinito, se establece a "true" la variable global "flex_EOF" que le indicará a Bison que se ha alcanzo el fin de archivo. */
                  }
%%