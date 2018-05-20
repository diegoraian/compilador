%option yylineno
%{
#include <stdio.h>
int contadorErro = 0;
%}

ESPACAMENTOS	[ \t\n]+
DIGITO	[0-9]
LETRAS [a-zA-Z]
NUM  {DIGITO}{DIGITO}*
NO_ID	({DIGITO}+({LETRAS}|{DIGITO})*)
ID	{LETRAS}({LETRAS}|{DIGITO})*
ESPACAMENTOS_LETRAS_NUMEROS {ID}{ESPACAMENTOS}{NUM}
KEYWORDS ("else")|("if")|("int")|("return")|("void")|("while")
SYM ((\<\=)|(\>\=)|(\=\=)|(\!\=))|[(\/)|(\*)|(\+)|(\-)|(\<)|(\>)|(\;)|(\,)|(\[)|(\])|(\{)|(\})|(\=)|(\()|(\))]
ERROR .
COMENTARIOS \\\*[^(\*|*\)]*\*\/
%%

{ESPACAMENTOS}	/* DESCONSIDERA ESPACOS EM BRANCO E TABULACOES*/



"/*"		{
		int c;
		int inicio = yylineno;
		
		while((c = input()) != 0) {
				if( c == EOF){	
					fprintf(yyout,"(%d,ERROR,\"/*\")\n",inicio);
					yyterminate();
					break;
				}
				
				else if(c == '*') {
					if((c = input()) == '/'){
						//fprintf(yyout,"(%d,SYM,\"/*\")\n",inicio);
						//fprintf(yyout,"(%d,SYM,\"*/\")\n",yylineno);
						break;
					} else {
						unput(c);
					}
				}
			
		}
}


{NUM}	fprintf(yyout,"(%d,NUM,\"%s\")\n",yylineno,yytext);

{NO_ID} {	
		fprintf(yyout,"(%d,ERROR,\"%s\")\n",yylineno,yytext);
		yyterminate();
	}

{KEYWORDS}   fprintf(yyout,"(%d,KEY,\"%s\")\n",yylineno,yytext);

{ID}	fprintf(yyout,"(%d,ID,\"%s\")\n",yylineno,yytext);









{SYM}	fprintf(yyout,"(%d,SYM,\"%s\")\n",yylineno,yytext);


{ERROR} {
		if ( contadorErro < 1){
			contadorErro++;
			fprintf(yyout,"(%d,ERROR,\"%s\")\n",yylineno,yytext);
			yyterminate();
		}
		
	}

%%

int main( int argc , char **argv )
	{
	if ( argc == 3) {
		yyin = fopen(argv[1],"r");
		yyout = fopen(argv[2],"w");
	 	yylex();
		
  		return 0;
	} else {
		return (-1);
	}
}
