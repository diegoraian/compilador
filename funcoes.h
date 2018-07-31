#include <stdbool.h>
#ifndef FUNCOES_H_ 
#define FUNCOES_H_

typedef struct node { 
  struct node *nodeA; 
  struct node *nodeB; 
  struct node *nodeC; 
  struct node *nodeD; 
  char *no; 
}tNode; 

typedef struct callFun {
  //char *tipo;
  char *nome;
  struct infoExpression *expre[512];
}tCallFun;

typedef struct infoExpression {
  struct opera *op;
  char *varName;
}tInfoExpression;

typedef struct opera {
  char *nome;
  char *op1;
  char *op2;
  char *simbolo;
}tOperacao;

typedef struct infoVar {
  char *tipo;
  char *nome;
  char *tamanVetor;
}tInfoVar;

typedef struct infoParam {
  char *tipo;
  char *nome;
  bool isVector;
}tInfoParam;

typedef struct funcScope {
  char *nameFunc;
  struct infoParam *param[512];
  struct infoVar *var[512];
  struct callFun *call[512];
}tFuncScope;

typedef struct expression {
  char *simbolo;
  struct node *lEsquerdo;
  struct node *lDireito;
}tExpression;

tNode *newnode(char* n, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode* nodeD);
void checkMain(tNode* no);
void findNameFunc(tNode *no);
void findParams(tNode *no);

#endif // FUNCOES_H_