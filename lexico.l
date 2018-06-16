%{
#include <stdio.h>
#include "parser.tab.h"
void yyerror(char *);
int contadorErro = 0;
%}

%option yylineno
/* This tells flex to read only one input file */
%option noyywrap

ESPACAMENTOS					[ \t\n]+
DIGITO							[0-9]
LETRAS 							[a-zA-Z]
NUM  							{DIGITO}{DIGITO}*

NO_ID							({DIGITO}+({LETRAS}|{DIGITO})*)
ID								{LETRAS}({LETRAS}|{DIGITO})*
ESPACAMENTOS_LETRAS_NUMEROS 	{ID}{ESPACAMENTOS}{NUM}

ERROR 							.
COMENTARIOS 					\\\*[^(\*|*\)]*\*\/

%%

{ESPACAMENTOS}		/* DESCONSIDERA ESPACOS EM BRANCO E TABULACOES*/

"/*"	{
			int c;
			int inicio = yylineno;
			
			while((c = input()) != 0) {
				if( c == EOF){	
					yyerror("LEXICAL ERROR");
					yyterminate();
					break;
				}

				else if(c == '*') {
					if((c = input()) == '/'){
						break;
					} else {
						unput(c);
					}
				}
				
			}
		}

{NUM}				{ yylval.numValue = atoi(yytext); return DIGIT; }

{NO_ID} 			{	
						yyerror("LEXICAL ERROR");
						yyterminate();
					}

"int"                       return INT;
"void"                      return VOID;
"if"                        return IF;
"while"                     return WHILE;
"else"                      return ELSE;
"return"                    return RETURN;
"("							return OPEN_PAREN;
")"							return CLOSE_PAREN;
","							return COMMA;
"{"							return OPEN_KEY;
"}"							return CLOSE_KEY;
";"							return END_LINE;
"="							return ATTRIB;
"+"							return PLUS;
"-"							return MINUS;
"*"							return TIMES;
"/"							return DIVIDE;
"<"							return MINNOR_THEN;
">"							return MAJOR_THEN;
"["							return OPEN_BRACKET;
"]"							return CLOSE_BRACKET;
"=="					    return EQUAL;
"!="					    return NEQUAL;
"<="					    return LEQUAL;
">="					    return BEQUAL;

{ID}				{ yylval.stringValue = strdup(yytext); return ID;}

{ERROR}         	{
		            	if ( contadorErro < 1){
			            	contadorErro++;
							yyerror("LEXICAL ERROR");
			            	yyterminate();
						}
		            }
		
%%

//acho que será chamado de outra forma
/*
int main( int argc , char **argv ){
	if ( argc == 3) {
		yyin = fopen(argv[1],"r");
		yyout = fopen(argv[2],"w");
	 	yylex();
		
  		return 0;
	} else {
		return (-1);
	}
}*/
