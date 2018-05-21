%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void    yyerror(const char *s);
int     yylex(void);
%}

//declaração das variáveis usadas no lexico
%union{
int		numValue;
char	*stringValue;
char	typeString[2048];
}
//onde a gramática vai começar
%start  START;
//declaração de tokens usados no lexico.l
%token                  INT VOID IF WHILE ELSE RETURN
%token <numValue>       DIGIT
%token <stringValue>    VARIABLE

%left EQUAL
%left NEQUAL
%left LEQUAL
%left BEQUAL
%left '+' '-'
%left '*' '/'
%left '<' '>'

%type <typeString> program
//--->continuar implementação