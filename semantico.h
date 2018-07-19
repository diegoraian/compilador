#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
#include <stdbool.h>
#include "funcoes.h"

tNode* raiz;
tOperacao* operacao;
tFuncScope* scope;          //escopo temporário
tFuncScope* funcoes;        //vetor de escopos

tInfoVar* var;              //escopo temporário
tInfoVar* varGlobais;       //vetor com variáveis globais

char    AST[20480];
char    ASM[20480];

void yyerror(const char *s); 
int  yylex(void); 
void mainLast(tNode *no);
void verificaTypeVar(tNode *no);
void findNameFunc(tNode *no);
void findParams(tNode *no);
void findVarDeclaration(tNode *no);
void findVarDeclarationGlobal(tNode *no);
void percorreArvore(tNode *no);
void analiseSemantica(tNode *no);
void checkMain(tNode* no);
tNode* newnode(char* no, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode *nodeD);
void imprimirArvore(tNode *no);
void opSimples(tNode *no);
void imprimeOpSimples();
void guardarRetornoMain();
void imprimeFunction(tNode *no);
void codigoPrintln();
void imprimePrintln(tNode *no);
void imprimirAsm(tNode *no);
int calcSizeVector(tFuncScope *vector);
int calcSizeVectorParam(tInfoParam *vector);
int calcSizeVectorVar(tInfoVar *vector);
