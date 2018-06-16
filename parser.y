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
    char* no;
}tNode ;

tNode* raiz;
//funções para criar os nós da arvore
tNode *newnode(char* n, tNode *l, tNode *r);
tNode *newnum(double d);

%}




//declaração das variáveis usadas no lexico
%union {
    int		numValue;
    char	*stringValue;
    struct node   *nodeValue;
}

//onde a gramática vai começar
%start  start;
%type <nodeValue> start
%type <nodeValue> program
%type <nodeValue> declaration-list
%type <nodeValue> declaration
%type <nodeValue> fun-declaration
%type <nodeValue> var-declaration
%type <nodeValue> empty;

//declaração de tokens usados no lexico.l
%token                   INT VOID IF WHILE ELSE RETURN
%token                   PLUS MINUS TIMES DIVIDE
%token                   OPEN_PAREN CLOSE_PAREN COMMA OPEN_KEY CLOSE_KEY END_LINE ATTRIB
%token                   MINNOR_THEN MAJOR_THEN OPEN_BRACKET CLOSE_BRACKET
%token  <numValue>       DIGIT
%token  <stringValue>    ID

//associatividade a esquerda, maior precedencia de baixo pra cima
%left PLUS MINUS
%left TIMES DIVIDE
%left EQUAL
%left NEQUAL
%left LEQUAL
%left BEQUAL
%left MINNOR_THEN MAJOR_THEN


//-----------------------------------------------------------------------------
%% 
//-----------------------------------------------------------------------------

start             :             program                                 {$$ = newnode("",$1,NULL);raiz = $$;}
program           :             declaration-list                         {$$ = newnode("[program ",$1,NULL);}
                  ;

declaration-list  :            declaration-list declaration               {$$ = newnode("[declaration-list ",$1,$2);}
                  |            declaration                                {$$ = newnode("[declaration ",$1,NULL);}
                  ;

declaration       :             var-declaration                           {$$ = newnode("[var-declaration ",$1,NULL);}
                  |             fun-declaration                           {$$ = newnode("[fun-declaration ",$1,NULL);}
                  ;

var-declaration   :             type-specifier ID END_LINE                                   {}
                  |             type-specifier ID OPEN_BRACKET DIGIT CLOSE_BRACKET  END_LINE           {}
                  ;

type-specifier    :             INT                                       {}
                  |             VOID                                       {}
                  ;

fun-declaration   :             type-specifier ID OPEN_PAREN params CLOSE_PAREN compound-stmt {}
                  ;           

params            :             param-list                                          {}
                  |             VOID                                                {}
                  ;

param-list        :             param-list COMMA param                              {}
                  |             param                                               {}  
                  ;
param             :             type-specifier ID                                   {}
                  |             type-specifier ID OPEN_BRACKET CLOSE_BRACKET        {}
                  ;

compound-stmt     :            OPEN_KEY local-declarations statement-list CLOSE_KEY      {}
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

expression-stmt   :             expression  END_LINE                {}
                  |             END_LINE                        {}
                  ;

selection-stmt    :             IF OPEN_PAREN expression CLOSE_PAREN statement                     {}
                  |             IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement      {}
                  ;
iteration-stmt    :             WHILE OPEN_PAREN expression CLOSE_PAREN statement                   {}
                  ;

return-stmt       :             RETURN END_LINE                                        {}
                  |             RETURN expression END_LINE                             {}
                  ;

expression        :             var ATTRIB expression                                {}
                  |             simple-expression                                 {}
                  ;
var               :             ID                                                {}
                  |             ID OPEN_BRACKET expression CLOSE_BRACKET                             {}                   
                  ;
simple-expression :             additive-expression relop additive-expression               {}
                  |             additive-expression                                         {}
                  ;

relop             :                LEQUAL                                           {}
                  |                MINNOR_THEN                                           {}
                  |                MAJOR_THEN                                          {}
                  |                BEQUAL                                          {}
                  |                EQUAL                                         {}
                  |                NEQUAL                                         {}
                  ;

additive-expression :         additive-expression addop term                      {}
                    |         term                                                {}                                
                    ;

addop               :           PLUS                                             {}
                    |           MINUS                                             {}
                    ;

term                :           term mulop factor                               {}
                    |           factor                                          {}
                    ;
mulop               :          TIMES                                              {}
                    |          DIVIDE                                              {}
                    ;

factor              :         OPEN_PAREN expression CLOSE_PAREN                                {}
                    |          var                                              {}
                    |          call                                             {}
                    |          DIGIT                                              {}
                    ;

call                :          ID OPEN_PAREN args CLOSE_PAREN                                  {}
                    ;

args                :          arg-list                                    {}
                    |          empty                                       {}
                    ;

arg-list            :           arg-list COMMA expression                         {}
                    |           expression                                      {}
                    ;

empty               :       %empty          {}
                    ;

//-----------------------------------------------------------------------------
%%
//-----------------------------------------------------------------------------

void yyerror(const char *s) {
	fprintf(stdout, "%s\n", s);
}

tNode* newnode(char* no, tNode *left, tNode *right){
    
    tNode *tree = malloc(sizeof(tNode));
    if(!tree){
        yyerror("vazio");
        exit(0);
    }
    tree->no = no;
    tree->left = left;
    tree->right = right;
    return tree;
}

void imprimirArvore(tNode *no){
    if(no == NULL){
        printf("Nó nullo");
        return;
    }
    printf("%s",no->no);
    imprimirArvore(no->left);
    imprimirArvore(no->right);
}

int main( int argc, char *argv[] ) {
	extern FILE *yyin;
    raiz = newnode("",NULL,NULL);
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
    imprimirArvore(raiz);
	yyparse();

	char *cmp = "[program";
	printf("%s", strAst);
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
