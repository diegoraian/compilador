%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void    yyerror(const char *s);
int     yylex(void);
char strAst[20480];

//nó que tem 2 filhos
struct node {
    struct node *left;
    struct node *right;
    int no;
};
//funções para criar os nós da arvore
struct node *newnode(int n, node *l, node *r);
struct node *newnum(double d);

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

program           :            declaration-list                           { strcpy(strAst, "[program "); strcat(strAst, $1); strcat(strAst, "]");}
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

type-specifier    :             int                                        {}
                  |             void                                       {}
                  ;

fun-declaration   :             type-specifier ID '(' params ')' compound-stmt {}
                  ;           

params            :             param-list                                 {}
                  |             void                                       {}
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
iteration-stmt    :             while '(' expression ')' statement                   {}
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

//-----------------------------------------------------------------------------
%%
//-----------------------------------------------------------------------------

void yyerror(const char *s) {
	fprintf(stdout, "%s\n", s);
}

struct node *newnode(int n, node *l, node *r){
    
    struct node *tree = malloc(sizeof(struct node));
    if(!tree){
        yyerror("vazio");
        exit(0);
    }
    tree->no = n;
    tree->left = l;
    tree->right = r;
    return tree;
}