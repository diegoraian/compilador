%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #define YYSTYPE int
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

%}
//declaração das variáveis usadas no lexico
%union{
    int		numValue;
    char	*stringValue;
}

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

// var:                ID
//                   | ID [ expression ]
%%
program            :    additive-expression             {printf("inicio\n");}
additive-expression:   additive-expression addop term   {}
                     | term                             {}
                     
addop:                  '+'                             {}
                     | '-'                              {}

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

int main( int argc , char **argv ){
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
	
    int retorno = yyparse();
	
	if(retorno !=0){
		exit(EXIT_FAILURE);	
	}
	
	
	// char *cmp = "[main";
	
	// if (strstr(strAst, cmp) == NULL){		
	// 	fclose(yyin);
	// 	fclose(fp);
	// 	yyerror("syntax error\n");
	// 	return 1;
	// }

	// fprintf(fp, "%s", strAst);
	
    fclose(yyin);
	
	fclose(fp);	
	
	return 0;
	// if ( argc == 3) {
	// 	yyin = fopen(argv[1],"r");
	// 	yyout = fopen(argv[2],"w");
	//  	yylex();
		
  	// 	return 0;
	// } else {
	// 	return (-1);
	// }
}

// struct node *newnode(char n, struct node *l, struct node *r){
//     struct node *tree = malloc(sizeof(struct node));
//     if(!tree){
//         yyerror("vazio");
//         exit(0);
//     }
//     tree->no = n;
//     tree->left = l;
//     tree->right = r;
//     return tree;
// }
