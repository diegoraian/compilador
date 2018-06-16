%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>
//#include <stdarg.h>
//#include "nodes.h"
void yyerror(const char *s);
int yylex(void);
int length;
char strAst[20480];
%}

//atribui um tipo de dado para iValue e iString
%union{
int		iValue;
char	*iString;
char	tString[2048];
}


//
%start			pstart

//tokens que serao usados no lexico
%token			DEF LET
%token			IF ELSE WHILE BREAK RETURN CONTINUE
%token <iValue> DEC
%token <iString>ID

%type <tString> program
%type <tString> decfunc
%type <tString> decvar
%type <tString> paramlist
%type <tString> block
%type <tString> stmt
%type <tString> assign
%type <tString> funccall
%type <tString> arglist
%type <tString> expr
%type <tString> binop
%type <tString> unop
%type <tString> exprlist
%type <tString> blocklist


%left OR			// menor precedencia, declarados primeiro
%left AND
%left EQUAL NEQUAL
%left '<' LE '>' GE
%left '+' '-'
%left '*' '/'
%left '!'
%left UNOT			// maior precedencia


%precedence IF
%precedence ELSE



//-----------------------------------------------------------------------------
%%
//-----------------------------------------------------------------------------

pstart		:	program								{	strcpy(strAst, "[program "); strcat(strAst, $1); strcat(strAst, "]"); }
			;

program		:	decvar								{	strcpy($$, $1); }
			|	decvar program						{	strcpy($$, $1); strcat($$, " "); strcat($$, $2); }
			|	decfunc								{	strcpy($$, $1) ; }
			|	decfunc program						{	strcpy($$, $1); strcat($$, " "); strcat($$, $2); }
			;

decvar		:	LET ID	';'							{	strcpy($$, "[decvar [" ); strcat($$, $2); strcat($$,"]]");	}
			|	LET ID '=' expr ';'					{	strcpy($$, "[decvar [" ); strcat($$, $2); strcat($$,"]" ); strcat($$, $4); strcat($$,"]"); }
			;

decfunc		:	DEF ID '(' ')' block				{	strcpy($$, "[decfunc [" ); strcat($$, $2); strcat($$,"] [paramlist] "); strcat($$, $5); strcat($$,"]"); }
			|	DEF ID '(' paramlist ')' block		{	strcpy($$, "[decfunc [" ); strcat($$, $2); strcat($$,"] [paramlist " ); strcat($$, $4); strcat($$,"] "); strcat($$, $6); strcat($$,"]"); }
			;

paramlist	:	ID									{	strcpy($$, "[" ); strcat($$, $1); strcat($$,"]"); }
			|	ID ',' paramlist					{	strcpy($$, "[" ); strcat($$, $1); strcat($$,"] "); strcat($$,$3); }
			;

block		:	'{' blocklist '}'					{	strcpy($$, "[block "); strcat($$, $2); strcat($$,"]"); }
			|	'{'	'}'								{	strcpy($$, "[block]"); }
			|										{	}
			;

blocklist	:	decvar								{	strcpy($$, $1); }
			|	decvar blocklist					{	strcpy($$, $1); strcat($$, " "); strcat($$, $2); }
			|	stmt								{	strcpy($$, $1); }
			|	stmt blocklist						{	strcpy($$, $1); strcat($$, " "); strcat($$, $2); }
			;

stmt		:	assign ';'							{	strcpy($$, $1); }
			|	funccall ';'						{	strcpy($$, $1); }
			|	IF expr block						{	strcpy($$, "[if " ); strcat($$, $2); strcat($$," " ); strcat($$, $3); strcat($$,"]"); }
			|	IF expr block ELSE block			{	strcpy($$, "[if " ); strcat($$, $2); strcat($$," "); strcat($$, $3); strcat($$, " "); strcat($$, $5); strcat($$,"]"); }
			|	WHILE expr block					{	strcpy($$, "[while " ); strcat($$, $2); strcat($$, " "); strcat($$, $3); strcat($$,"]"); }
			|	RETURN ';'							{	strcpy($$, "[return]"); }
			|	RETURN expr ';'						{	strcpy($$, "[return " ); strcat($$, $2); strcat($$,"]"); }
			|	BREAK ';'							{	strcpy($$, "[break]"); }
			|	CONTINUE ';'						{	strcpy($$, "[continue]"); }
			;

assign		:	ID '=' expr							{	strcpy($$, "[assign [" ); strcat($$, $1); strcat($$,"] "); strcat($$, $3); strcat($$,"]"); }
			;

funccall	:	ID '(' ')'							{	strcpy($$, "[funccall [" ); strcat($$, $1); strcat($$,"] [arglist]]"); }
			|	ID '(' arglist ')'					{	strcpy($$, "[funccall [" ); strcat($$, $1); strcat($$,"] [arglist " ); strcat($$, $3); strcat($$,"]]"); }
			;

arglist		:	expr								{	strcpy($$, $1); }
			|	arglist ',' expr					{	strcpy($$, $1); strcat($$, " "); strcat($$,$3); }
			;

exprlist	:	'(' expr ')'						{	strcpy($$, $2); }
			//|	expr exprlist						{	strcpy($$, $1); strcat($$, $2); }
			//|	expr 								{	strcpy($$, $1); }
			;
			
expr		:	expr binop expr					{	strcpy($$, "[" ); strcat($$, $2); strcat($$, " "); strcat($$, $1); strcat($$, " "); strcat($$, $3); strcat($$,"]"); }
			|	unop expr							{	strcpy($$, "[" ); strcat($$, $1); strcat($$, " "); strcat($$, $2); strcat($$,"]"); }
			|	unop exprlist						{	strcpy($$, "[" ); strcat($$, $1); strcat($$, " "); strcat($$, $2); strcat($$,"]"); }
			|	exprlist							{	strcpy($$, $1); }
			|	funccall							{	strcpy($$, $1); }
			|	DEC									{
														length = snprintf(NULL, 0,"%d", $1);
														char str[length + 1];
														snprintf(str, length + 3, "[%d]", $1);
														strcpy($$, str);
													}
			|	ID									{	strcpy($$, "[" ); strcat($$, $1); strcat($$,"]"); }
			;

binop		:	'+'									{	strcpy($$, "+"); }
			|	'-'									{	strcpy($$, "-"); }
			|	'*'									{	strcpy($$, "*"); }
			|	'/'									{	strcpy($$, "/"); }
			|	'<'									{	strcpy($$, "<"); }
			|	LE									{	strcpy($$, "<="); }
			|	'>'									{	strcpy($$, ">"); }
			|	GE									{	strcpy($$, ">="); }
			|	EQUAL								{	strcpy($$, "=="); }
			|	NEQUAL								{	strcpy($$, "!="); }
			|	AND									{	strcpy($$, "&&"); }
			|	OR									{	strcpy($$, "||"); }
			;

unop		:	'-' %prec UNOT						{	strcpy($$, "-"); }
			|	'!'									{	strcpy($$, "!"); }

			;


//-----------------------------------------------------------------------------
%%
//-----------------------------------------------------------------------------


/* Called by yyparse on error */
void yyerror(const char *s) {
	fprintf(stdout, "%s\n", s);
}

int main( int argc, char *argv[] ) {
	extern FILE *yyin;
	 //++argv; −−argc;
	//yyin = fopen( argv[0], "r" );
	//yydebug = 1;
	//errors = 0;
	//yyparse ();
	//printf("%s", strAst);
	//return 0;

	if( argc != 3){
		printf("Quantidade de argumentos invalida!\n");
		return 1;
	}

	yyin = fopen(argv[1], "r");

	if (yyin == NULL){
		printf("Erro ao abrir o arquivo: %s \n", argv[1]);
		return 1;
	}

	FILE *fp;
	fp = fopen(argv[2], "w+");
	if (fp == NULL){
		printf("Erro ao abrir o arquivo: %s \n", argv[2]);
		return 1;
	}

	yyparse();

	char *cmp = "[main";
	
	if (strstr(strAst, cmp) == NULL){		
		fclose(yyin);
		fclose(fp);
		yyerror("syntax error\n");
		return 1;
	}
	
	fprintf(fp, "%s", strAst);

	fclose(yyin);
	fclose(fp);

	return 0;

}

