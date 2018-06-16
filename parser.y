%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void    yyerror(const char *s);
int     yylex(void);

//nó que tem 2 filhos
struct node {
    struct node *left;
    struct node *right;
    char no;
};

//funções para criar os nós da arvore
struct node *newnode(int n, struct node *l, struct node *r);

#define YYSTYPE double

//declaração das variáveis usadas no lexico
%union{
    int		numValue;
    char	*stringValue;
}
%}

//onde a gramática vai começar
%start  program;

//declaração de tokens usados no lexico.l
%token                   INT VOID IF WHILE ELSE RETURN
%token  <numValue>       DIGIT
%token  <stringValue>    VARIABLE

%type <node> program
%type <node> additive-expression
%type <node> addop
%type <node> term
%type <node> mulop
%type <node> factor

//associatividade a esquerda, maior precedencia de baixo pra cima
%left EQUAL
%left NEQUAL
%left LEQUAL
%left BEQUAL
%left '+' '-'
%left '*' '/'
%left '<' '>'

// %type <typeString> program
//--->continuar implementação
// var:                ID
//                   | ID [ expression ]
%%
program            :    additive-expression             {}
additive-expression:   additive-expression addop term   {}
                     | term                             {}
                     
addop:              '+'                                 {}
                  | '-'                                 {}

term:               term mulop factor                   {}
                  | factor                              {}

mulop:              '*'
                  | '/'

factor:                                                 {}
// ( expression )
                //   | var
                //   | call
                //   | NUM

// call:               ID ( args )

// args:               arg-list
//                   | empty

// arg-list:           arg-list , expression
//                   | expression
%%

void yyerror(const char *s) {
	fprintf(stdout, "%s\n", s);
}

struct node *newnode(char n, struct node *l, struct node *r){
    
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