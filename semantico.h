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

tInfoVar* var;              //var global temporária
tInfoVar* varGlobais;       //vetor com variáveis globais

tExpression* expression;    //cada expressão

tCallFun* call;

char    AST[20480];
char    ASM[20480];
int contadorFuncoes;

void yyerror(const char *s); 
int  yylex(void); 
void mainLast(tNode *no);
void verificaTypeVar(tNode *no);
void findParams(tNode *no);
void findVarDeclaration(tNode *no);
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
void findGlobalDeclaration(tNode *no);
void findCalls(tNode *no);
void gerarStatements(tNode *node);
void finishCallFunction(tNode *node);
void startCallFunction();
void out(char* texto);
void outEntry(char* texto);