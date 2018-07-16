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

typedef struct opera {
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
  struct infoParam *param[1024];
  struct infoVar *var[1024];
}tFuncScope;

tNode *newnode(char* n, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode* nodeD);
void checkMain(tNode* no);
void findNameFunc(tNode *no);
void findParams(tNode *no);

#endif // FUNCOES_H_