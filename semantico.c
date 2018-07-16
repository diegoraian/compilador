#include "semantico.h"
#include "funcoes.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
#include <stdbool.h>

int temMain = 0;
int size=0;
int sizeVar=0;

void push_back(tFuncScope *no){
  funcoes[size] = *no;
  size++;
}

void push_backVar(tInfoVar *no){
  varGlobais[sizeVar] = *no;
  sizeVar++;
}

int calcSizeVector(tFuncScope *vector){
  int size=0;
  while((&vector[size])->nameFunc != NULL){
    size++;
  }
  return size;
}

int calcSizeVectorParam(tInfoParam *vector){
  int size=0;
  while((&vector[size])->tipo != NULL){
    size++;
  }
  return size;
}

int calcSizeVectorVar(tInfoVar *vector){
  int size=0;
  while((&vector[size])->tipo != NULL){
    size++;
  }
  return size;
}

void clearStruct(tFuncScope *no){
  if(no != NULL){
    no->nameFunc = NULL;
    for(int i=0; i<2; i++){
      no->param[i]->nome = NULL;
      no->param[i]->tipo = NULL;
      no->param[i]->isVector = NULL;
    }
    for(int i=0; i<3; i++){
      no->var[i]->nome = NULL;
      no->var[i]->tipo = NULL;
      no->var[i]->tamanVetor = NULL;
    }
      scope = malloc(sizeof(tFuncScope)); 
  }
}

void clean(char *var) {
  int i = 0;
  while(var[i] != '\0') {
      var[i] = '\0';
      i++;
  }
}

void yyerror(const char *s) { 
  fprintf(stdout, "%s\n", s);
  exit(0); 
}

void mainLast(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->nodeA->no,"declist") == 0){
    mainLast(no->nodeA);
  }
  if(no->nodeD != NULL){
    printf("%s D\n",no->nodeD->no);
    if(strcmp(no->nodeD->no,"fun-declaration") == 0){
      if(strcmp(no->nodeD->nodeB->no,"main")){
        yyerror("last nodo isnt mainD");
        clean(AST);
      }
    }else{
      yyerror("has something after main");
      clean(AST);
    }
  }else{
    if(no->nodeC != NULL){
      printf("%s C\n",no->nodeC->no);
      if(strcmp(no->nodeC->no,"fun-declaration") == 0){
        if(strcmp(no->nodeC->nodeB->no,"main")){
          yyerror("last nodo isnt mainC");
          clean(AST);
        }
      }else{
        yyerror("has something after main");
        clean(AST);
      }
    }else{
      if(no->nodeB != NULL){
        printf("%s B\n",no->nodeB->no);
        if(strcmp(no->nodeB->no,"fun-declaration") == 0){
          if(strcmp(no->nodeB->nodeB->no,"main")){
            yyerror("last nodo isnt mainB");
            clean(AST);
          }
        }else{
          yyerror("has something after main");
          clean(AST);
        }
      }else{
        if(no->nodeA != NULL){
          printf("%s A\n",no->nodeA->no);
          // printf("%s A\n",no->nodeA->nodeB->no);
          if(strcmp(no->nodeA->no,"fun-declaration") == 0){
            if(strcmp(no->nodeA->nodeB->no,"main")){
              yyerror("last nodo isnt mainA");
              clean(AST);
            }
          }else{
            yyerror("has something after main");
            clean(AST);
          }
        }
      }
    }
  }
}

void verificaTypeVar(tNode *no){ 
  if(no == NULL){ 
    return; 
  }
  if(strcmp(no->no,"var-declaration") == 0 && strcmp(no->nodeA->no,"void") == 0){
    clean(AST);
  }
  if(strcmp(no->no,"param") == 0 && strcmp(no->nodeA->no,"void") == 0){
    clean(AST);
  }
  verificaTypeVar(no->nodeA);
  verificaTypeVar(no->nodeB);
  verificaTypeVar(no->nodeC);
  verificaTypeVar(no->nodeD);
}
            
void findNameFunc(tNode *no){
  if(strcmp(no->no,"var-declaration") == 0){
  }
}

int pos = 0;
void findParams(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no, "param") == 0){
    tInfoParam *param = malloc(sizeof(tInfoParam));
    scope->param[pos] = param;
    scope->param[pos]->tipo = no->nodeA->no;
    scope->param[pos]->nome = no->nodeB->no;
    if(no->nodeC != NULL){
      scope->param[pos]->isVector = true;
    }else{
      scope->param[pos]->isVector = false;
    }
    pos++;
  }
  findParams(no->nodeA); 
  findParams(no->nodeB); 
  findParams(no->nodeC); 
  findParams(no->nodeD); 
}

int posVar = 0;
void findVarDeclaration(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no, "var-declaration") == 0){
    tInfoVar *var = malloc(sizeof(tInfoVar));
    scope->var[posVar] = var;
    scope->var[posVar]->tipo = no->nodeA->no;
    scope->var[posVar]->nome = no->nodeB->no;
    if(no->nodeC != NULL){
      scope->var[posVar]->tamanVetor = no->nodeC->no;
    }else{
      scope->var[posVar]->tamanVetor = NULL;
    }
    posVar++;
  }
  findVarDeclaration(no->nodeA); 
  findVarDeclaration(no->nodeB); 
  findVarDeclaration(no->nodeC); 
  findVarDeclaration(no->nodeD); 
}

void percorreArvore(tNode *no){ 
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no,"") != 0){

    if(strcmp(no->no,"var-declaration") == 0){
      var->tipo = no->nodeA->no;
      var->nome = no->nodeB->no;
      printf("%s\n",var->tipo);
      printf("%s\n",var->nome);
    }

    if(strcmp(no->no,"fun-declaration") == 0){
      scope->nameFunc = no->nodeB->no;
    }
    if((strcmp(no->no, "params") == 0) && (no->nodeA != NULL)){
      findParams(no);
    }else if((strcmp(no->no, "params") == 0) && (no->nodeA == NULL)){
      tInfoParam *param = malloc(sizeof(tInfoParam));
      scope->param[0] = param;
      scope->param[0]->tipo = "void";
    }
    if(strcmp(no->no, "compound-stmt") == 0){
      findVarDeclaration(no);
      push_back(scope);
      free(scope);
      scope = malloc(sizeof(tFuncScope));
      pos=0;
      posVar=0;
    }
  }
  percorreArvore(no->nodeA); 
  percorreArvore(no->nodeB); 
  percorreArvore(no->nodeC); 
  percorreArvore(no->nodeD);
}


void analiseSemantica(tNode *no){
  if(no == NULL){
    return;
  }
  verificaTypeVar(no);
  percorreArvore(no);
  // mainLast(no);
}
 
 void checkMain(tNode* no){
  if ( !strcmp(no->nodeB->no, "main") ){
    if(temMain==1){
      clean(AST);
      yyerror("has more the one main");
    }
    temMain = 1;
    if ( strcmp(no->nodeA->no, "void") ){
      clean(AST);
      yyerror("main has to be type void");
    }
    if ( no->nodeC->nodeA != NULL ){
      clean(AST);
      yyerror("main cant have params");
    }
  }
  else{
    if(temMain==1){
      clean(AST);
      yyerror("has something after main");
    }
  }
  if(!strcmp(no->nodeB->no, "println")){
    clean(AST);
    yyerror("cant redefine println");
  }
  if(!strcmp(no->nodeB->no, "input")){
    clean(AST);
    yyerror("cant redefine input");
  }
}

tNode* newnode(char* no, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode *nodeD){ 

  tNode *tree = malloc(sizeof(tNode)); 
  if(!tree){ 
      yyerror("vazio"); 
      exit(0);
  }
    tree->no = malloc(20);
    strcpy(tree->no, no); 

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
  // printf("%s",no->no); 
  if(strcmp(no->no,"") != 0){
    strcat(AST,"[");
    strcat(AST,no->no);
  }
  imprimirArvore(no->nodeA); 
  imprimirArvore(no->nodeB); 
  imprimirArvore(no->nodeC); 
  imprimirArvore(no->nodeD); 
  if(strcmp(no->no,"") != 0){  
      strcat(AST,"]");
  }
}


void opSimples(tNode *no){
  if(strcmp(no->no,"-")==0){
    operacao->simbolo = no->no;
    operacao->op1 = no->nodeA->nodeA->no;
    operacao->op2 = no->nodeB->nodeA->no;
  }
  if(strcmp(no->no,"+")==0){
    operacao->simbolo = no->no;
    operacao->op1 = no->nodeA->nodeA->no;
    operacao->op2 = no->nodeB->nodeA->no;
  }
}

void imprimeOpSimples(){
  //grava o valor do primeiro parametro
  strcat(ASM,"li $a0, ");
  strcat(ASM,operacao->op1);
  //da um push
  strcat(ASM,"\nsw $a0, 0($sp)\n");
  strcat(ASM,"addiu $sp, $sp, -4\n");
  //grava o valor do segundo parametro
  strcat(ASM,"li $a0, ");
  strcat(ASM,operacao->op2);
  //da um pop
  strcat(ASM,"\nlw $t1, 4($sp)\n");
  strcat(ASM,"addiu $sp, $sp, 4\n");
  //realiza a operação
  if(strcmp(operacao->simbolo,"+") == 0)
    strcat(ASM,"add $a0, $t1, $a0\n");
  if(strcmp(operacao->simbolo,"-") == 0)
    strcat(ASM,"sub $a0, $t1, $a0\n");
  //da um push com o resultado
  strcat(ASM,"sw $a0, 0($sp)\n");
  strcat(ASM,"addiu $sp, $sp, -4\n");
}

void guardarRetornoMain(){
  //push na pilha com o endereço de retorno
  strcat(ASM,"sw $ra, 0($sp)\n");
  strcat(ASM,"addiu $sp, $sp, -4\n");
}

void imprimeFunction(tNode *no){
  if(strcmp(no->no,"fun-declaration") == 0){
    strcat(ASM,"_f_");
    strcat(ASM,no->nodeB->no);
    strcat(ASM,":\n");
    if(strcmp(no->nodeB->no, "main") == 0){
      guardarRetornoMain();
      if(operacao!=NULL)
        imprimeOpSimples();
    }
  }
}

void codigoPrintln(){
  //eu acho que esse código é default
  strcat(ASM,"lw $a0, 4($sp)\n");
  strcat(ASM,"li $v0, 1\n");
  strcat(ASM,"syscall\n");
  strcat(ASM,"li $v0, 11\n");
  strcat(ASM,"li $a0, 0x0a\n");
  strcat(ASM,"syscall\n");
  strcat(ASM,"addiu $sp, $sp, 4\n");
  strcat(ASM,"li $a0, 0\n");
  strcat(ASM,"j $ra\n");
}

void imprimePrintln(tNode *no){
  if(strcmp(no->no,"call") == 0 && strcmp(no->nodeA->no,"println") == 0){
    strcat(ASM,"_f_");
    strcat(ASM,no->nodeA->no);
    strcat(ASM,":\n");
    codigoPrintln();
  }
}

void imprimirAsm(tNode *no){ 
  if(no == NULL){ 
    return; 
  }
  if(strcmp(no->no,"") != 0){
    opSimples(no);
  }
  imprimirAsm(no->nodeA); 
  imprimirAsm(no->nodeB); 
  imprimirAsm(no->nodeC); 
  imprimirAsm(no->nodeD);

  if(strcmp(no->no,"") != 0){
    imprimeFunction(no);
    imprimePrintln(no);
  }
}
 