####################################################################
# 
#  Makefile para la generación del ejecutable 'cset': un compilador
#  para el lenguaje de programación de alto nivel Set.
#
####################################################################

CC = g++
# En el diseño del léxico y la gramática del lenguaje Set (archivos 'set_bison_parser.y' y 'set_flex_lexer.l') se utilizan funciones de C++ pero flex y bison siempre generan archivos fuentes en C, en este caso generarían archivos fuentes en C que utilizan funciones de C++, así que para que no se produzcan errores de compilación se utiliza la orden 'g++' (CC = g++) en vez de 'gcc', ya que ésta incluye automáticamente las librerías de C++ y además compila, por defecto, los archivos fuente del lenguaje C como si fueran archivos fuente de C++ ('gcc' compilaría los archivo fuente en C como C y los C++ como archivos fuentes C++).

PARSER_NAME = set_bison_parser
LEXER_NAME = set_flex_lexer
OBJECTS = set_compiler_main.o $(PARSER_NAME).tab.o $(LEXER_NAME).yy.o
COMPILER_NAME = cset

all: $(COMPILER_NAME)

$(PARSER_NAME).tab.c $(PARSER_NAME).tab.h: $(PARSER_NAME).y
	bison --report=state -d $(PARSER_NAME).y
	# En programas simples la función 'yylex()' se define a menudo al final del archivo de la gramática de Bison. Si 'yylex()' se define en un archivo fuente por separado, como es el caso actual que se define en el archivo 'set_flex_lexer.yy.c' generado con la orden 'flex set_flex_lexer.l', necesitamos que las definiciones de las macros de tipos de tokens estén disponibles ahí (necesitamos que estén disponibles en 'set_flex_lexer.yy.c'). Con la opción '-d' del comando 'bison' se escriben dichas definiciones de macros en un archivo de cabecera por separado (en el archivo 'set_bison_parser.tab.h') para que se puedan incluir en los archivos fuente que las necesiten. En esta caso se incluye en 'set_flex_lexer.yy.c', siempre y cuando se escriba lo siguiente al principio del archivo 'set_flex_lexer.l':
	#%{ 
			#include 'set_bison_parser.tab.h' 
	#%}

$(LEXER_NAME).yy.c: $(LEXER_NAME).l $(PARSER_NAME).tab.h
	flex $(LEXER_NAME).l

$(OBJECTS): $(PARSER_NAME).tab.h

$(COMPILER_NAME): $(OBJECTS)
	$(CC) -o $@ $^ #EXPLICAR SU FUNCIONAMIENTO EXACTO)

clean:
	rm -f *.yy.* *.tab.* *.output *.o ~* *.exe; find . -perm +100 -type f -delete
	# La utilidad para sistemas basado en Unix 'rm' intenta eliminar los archivo de tipo no directorio especificados en la línea de comandos. Si los permisos del archivo no permiten la escritura, y el dispositivo de entrada estándar es una terminal, se le pide al usuario (en la salida de error estándar) su confirmación. Con la opción '-f' se intenta eliminar los archivos sin pedir confirmación, independientemente de los permisos del archivo. Los archivos a eliminar son:
	# *.yy.*: cualquier analizador léxico generado con flex.
	# *.tab.*: cualquier analizador sintáctico generado con bison.
	# '*.output': cualquier archivo (generado con la opción '--report=state' del comando 'bison').
	# '*.o': cualquier archivo objeto objeto generado con g++.
	# *.exe: cualquier ejecutable de MS Windows.
	# El punto y coma (;) permite ejecuta el siguiente comando después de que termine 'rm': find . -perm +100 -type f -delete (elimina cualquier ejecutable de Unix. EXPLICAR SU FUNCIONAMIENTO EXACTO)