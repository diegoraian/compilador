%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void    yyerror(const char *s);
int     yylex(void);
char strAst[20480];

//nó que tem 2 filhos
typedef struct node {
    struct node *left;
    struct node *right;
    int no;
}tNode ;
//funções para criar os nós da arvore
tNode *newnode(int n, tNode *l, tNode *r);
tNode *newnum(double d);

%}




//declaração das variáveis usadas no lexico
%union{
    int		numValue;
    char	*stringValue;
}

//onde a gramática vai começar
%start  program;

//declaração de tokens usados no lexico.l
%token <char>            ID
%token  <numValue>       NUM
%token                   INT VOID IF WHILE ELSE RETURN
%token  <numValue>       DIGIT
%token  <stringValue>    VARIABLE

//associatividade a esquerda, maior precedencia de baixo pra cima
%left EQUAL
%left NEQUAL
%left LEQUAL
%left BEQUAL
%left '+' '-'
%left '*' '/'
%left '<' '>'


//-----------------------------------------------------------------------------
%% 
//-----------------------------------------------------------------------------

program           :            declaration-list                           { strcpy(strAst, "[program "); ; strcat(strAst, "]");}
                  ;

declaration-list  :            declaration-list declaration               {}
                  |            declaration                                {}
                  ;

declaration       :             var-declaration                           {}
                  |             fun-declaration                           {}
                  ;

var-declaration   :             type-specifier ID ';'                     {}
                  |             type-specifier ID '[' NUM ']'             {}
                  ;

type-specifier    :             "int"                                        {}
                  |             "void"                                       {}
                  ;

fun-declaration   :             type-specifier ID '(' params ')' compound-stmt {}
                  ;           

params            :             param-list                                 {}
                  |             "void"                                       {}
                  ;

param-list        :             param-list ',' param                        {}
                  |             param                                       {}
                  ;
param             :             type-specifier ID
                  |             type-specifier ID '[' ']'
                  ;

compound-stmt     :             local-declarations statement-list               {}
                  ;

local-declarations:             local-declarations var-declaration              {}
                  |             empty                                           {}
                  ;

statement-list    :             statement-list statement                        {}
                  |             empty                                           {}
                  ;

statement         :             expression-stmt                                 {}
                  |             compound-stmt                                   {}
                  |             selection-stmt                                  {}
                  |             iteration-stmt                                  {}
                  |             return-stmt                                     {}
                  ;

expression-stmt   :             expression
                  ;

selection-stmt    :             "if" '(' expression ')' statement                     {}
                  |             "if" '(' expression ')' statement "else" statement      {}
                  ;
iteration-stmt    :             "while" '(' expression ')' statement                   {}
                  ;

return-stmt       :             "return" ';'                                        {}
                  |             "return" expression ';'                             {}
                  ;

expression        :             var '=' expression                                {}
                  |             simple-expression                                 {}
                  ;
var               :             ID                                                {}
                  |             ID '[' expression ']'                             {}                   
                  ;
simple-expression :             additive-expression relop additive-expression
                  |             additive-expression
                  ;

relop             :                '<''='                                           {}
                  |                '<'                                           {}
                  |                '>'                                           {}
                  |                '>''='                                          {}
                  |                '=''='                                         {}
                  |                '!''='                                         {}
                  ;

additive-expression :         additive-expression addop term                      {}
                    |         term                                                {}                                
                    ;

addop               :           '+'                                             {}
                    |           '-'                                             {}
                    ;

term                :           term mulop factor                               {}
                    |           factor                                          {}
                    ;
mulop               :          '*'                                              {}
                    |          '/'                                              {}
                    ;

factor              :         '(' expression ')'                                {}
                    |          var                                              {}
                    |          call                                             {}
                    |          NUM                                              {}
                    ;

call                :          ID '(' args ')'                                  {}
                    ;

args                :               arg-list                                    {}
                    |               empty                                       {}
                    ;

arg-list            :           arg-list ',' expression                         {}
                    |           expression                                      {}
                    ;

empty               :       ""          {}
                    ;

//-----------------------------------------------------------------------------
%%
//-----------------------------------------------------------------------------

void yyerror(const char *s) {
	fprintf(stdout, "%s\n", s);
}

tNode *newnode(int n, tNode *l, tNode *r){
    
    tNode *tree = malloc(sizeof(tNode));
    if(!tree){
        yyerror("vazio");
        exit(0);
    }
    tree->no = n;
    tree->left = l;
    tree->right = r;
    return tree;
}

int main( int argc, char *argv[] ) {
	extern FILE *yyin;

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

