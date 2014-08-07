int yyparse();

int main(int i, char** options)
{
   //FILE *myfile = fopen("prueba.mset", "r");
   //yyin = myfile;

   /* Se llama a la función 'yyparse' para hacer que el análisis comience. Esta función lee tokens. ejecuta acciones y por último retorna cuando se encuentre con el final del archivo o un error de sintaxis del que no puede recuperarse. Puede también escribir acciones que ordenen a "yyparse" retornar inmediatamente sin leer más allá. El valor devuelto por 'yyparse' es:
   - 0 si el análisis tuvo éxito (el retorno se debe al final del archivo).
   - 1 si el análisis falló (el retorno es debido a un error de sintaxis).*
   - En una acción, puede provocar el retorno inmediato de 'yyparse' utilizando estas macros:
     - 'YYACCEPT': Retorna inmediatamente con el valor 0 (para indicar éxito).
     - 'YYABORT': Retorna inmediatamente con el valor 1 (para indicar fallo).
   */
   //do
   //{
     yyparse();
   //}
   //while (!feof(yyin));

   //cout << endl << options[1] << endl << options[2];

   return 0;
}