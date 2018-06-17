%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void    yyerror(const char *s);
int     yylex(void);
char strAst[20480];

//nó que tem 2 filhos
typedef struct node {
    struct node *nodeA;
    struct node *nodeB;
    struct node *nodeC;
    struct node *nodeD;
    char* no;
}tNode ;


tNode* raiz;
//funções para criar os nós da arvore
tNode *newnode(char* n, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode *nodeD);
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
%type <nodeValue> empty
%type <nodeValue> type-specifier
%type <nodeValue> compound-stmt
%type <nodeValue> params
%type <nodeValue> param
%type <nodeValue> param-list

//declaração de tokens usados no lexico.l
%token  <stringValue>    INT VOID IF WHILE ELSE RETURN
%token  <stringValue>    PLUS MINUS TIMES DIVIDE
%token  <stringValue>    OPEN_PAREN CLOSE_PAREN COMMA OPEN_KEY CLOSE_KEY END_LINE ATTRIB
%token  <stringValue>    MINNOR_THEN MAJOR_THEN OPEN_BRACKET CLOSE_BRACKET
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

start             :             program                                 {$$ = newnode("",$1,NULL,NULL,NULL); raiz = $$;}
program           :             declaration-list                         {$$ = newnode("[program ",$1,NULL,NULL,NULL);}
                  ;

declaration-list  :            declaration-list declaration               {$$ = newnode("",$1,$2,NULL,NULL);}
                  |            declaration                                {$$ = newnode("",$1,NULL,NULL,NULL);}
                  ;

declaration       :             var-declaration                           {$$ = newnode("[var-declaration ",$1,NULL,NULL,NULL);}
                  |             fun-declaration                           {$$ = newnode("[fun-declaration ",$1,NULL,NULL,NULL);}
                  ;

var-declaration   :             type-specifier ID END_LINE                                   {$$ = newnode($2,$1,NULL,NULL,NULL);}
                  |             type-specifier ID OPEN_BRACKET DIGIT CLOSE_BRACKET  END_LINE           {$$ = newnode($2,$1,NULL,NULL,NULL);}
                  ;

type-specifier    :             INT                                       {$$ = newnode("[INT]",NULL,NULL,NULL,NULL);}
                  |             VOID                                       {$$ = newnode("[VOID]",NULL,NULL,NULL,NULL);}
                  ;

fun-declaration   :             type-specifier ID OPEN_PAREN params CLOSE_PAREN compound-stmt {$$ = newnode($2,$1,$4,$6,NULL);}
                  ;           

params            :             param-list                                          {$$ = newnode("",$1,NULL,NULL,NULL);}
                  |             VOID                                                {$$ = newnode("[VOID]",NULL,NULL,NULL,NULL);}
                  ;

param-list        :             param-list COMMA param                              {$$ = newnode("",$1,$3,NULL,NULL);}
                  |             param                                               {$$ = newnode("",$1,NULL,NULL,NULL);}  
                  ;
param             :             type-specifier ID                                   {$$ = newnode($2,$1,NULL,NULL,NULL);}
                  |             type-specifier ID OPEN_BRACKET CLOSE_BRACKET        {$$ = newnode($2,$1,NULL,NULL,NULL);}
                  ;

compound-stmt     :            OPEN_KEY local-declarations statement-list CLOSE_KEY      {$$ = newnode($2,$1,NULL,NULL,NULL);}
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

tNode* newnode(char* no, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode *nodeD){
    
    tNode *tree = malloc(sizeof(tNode));
    if(!tree){
        yyerror("vazio");
        exit(0);
    }

    tree->no = no;
    tree->nodeA = nodeA;
    tree->nodeB = nodeB;
    tree->nodeC = nodeC;
    tree->nodeD = nodeD;
    return tree;
}



void imprimirArvore(tNode *no){
    if(no == NULL){
        return;
    }
    if(no->no != "")
        printf("%s\n",no->no);
    imprimirArvore(no->nodeA);
    imprimirArvore(no->nodeB);
    imprimirArvore(no->nodeC);
    imprimirArvore(no->nodeD);
    
}

int main( int argc, char *argv[] ) {
	extern FILE *yyin;
    raiz = newnode("",NULL,NULL,NULL,NULL);
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
	imprimirArvore(raiz);
	fprintf(fp, "%s", strAst);

	fclose(yyin);
	fclose(fp);

	return 0;

}
